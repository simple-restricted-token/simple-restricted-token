const ManagedWhitelistTokenMock = artifacts.require('ManagedWhitelistTokenMock')

contract('ManagedWhitelistToken', ([owner, manager, operator, ...accounts]) => {
  const initialAccount = owner
  const transferValue = '100000000000000000'
  const initialBalance = '100000000000000000000'

  let token
  let tokenTotalSupply
  let sender = owner
  let recipient = operator
  let SUCCESS_CODE
  let SUCCESS_MESSAGE
  let SEND_NOT_ALLOWED_CODE
  let SEND_NOT_ALLOWED_ERROR
  let RECEIVE_NOT_ALLOWED_CODE
  let RECEIVE_NOT_ALLOWED_ERROR
  before(async () => {
    token = await ManagedWhitelistTokenMock.new(initialAccount, initialBalance)
    tokenTotalSupply = await token.totalSupply()
    SUCCESS_CODE = await token.SUCCESS_CODE()
    SUCCESS_MESSAGE = await token.SUCCESS_MESSAGE()
    SEND_NOT_ALLOWED_CODE = await token.SEND_NOT_ALLOWED_CODE()
    SEND_NOT_ALLOWED_ERROR = await token.SEND_NOT_ALLOWED_ERROR()
    RECEIVE_NOT_ALLOWED_CODE = await token.RECEIVE_NOT_ALLOWED_CODE()
    RECEIVE_NOT_ALLOWED_ERROR = await token.RECEIVE_NOT_ALLOWED_ERROR()
  })

  let senderBalanceBefore
  let recipientBalanceBefore
  beforeEach(async () => {
    senderBalanceBefore = await token.balanceOf(sender)
    recipientBalanceBefore = await token.balanceOf(recipient)
  })

  it('should allow owner to add a manager', async () => {
    await token.addManager(manager, { from: owner })
    const isManager = await token.isManager({ from: manager })
    assert.equal(isManager, true)
  })
  
  it('should detect restriction for transfer to non-whitelisted recipient', async () => {
    const code = await token.detectTransferRestriction(sender, recipient, transferValue)
    assert(code.eq(RECEIVE_NOT_ALLOWED_CODE))
  })

  it('should return receive-not-allowed error message for transfer to non-whitelisted recipient error code', async () => {
    const message = await token.messageForTransferRestriction(RECEIVE_NOT_ALLOWED_CODE)
    assert.equal(RECEIVE_NOT_ALLOWED_ERROR, message)
  })

  it('should allow owner to whitelist a receiving address', async () => {
    await token.addToReceiveAllowed(operator, { from: owner })
    const isWhitelisted = await token.receiveAllowed(operator)
    assert.equal(isWhitelisted, true)
  })

  it('should allow token transfer to whitelisted recipient', async () => {
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert.equal(senderBalanceAfter.valueOf(), senderBalanceBefore.minus(transferValue).valueOf())
    assert.equal(recipientBalanceAfter.valueOf(), recipientBalanceBefore.plus(transferValue).valueOf())
  })

  it('should detect success for valid transfer', async () => {
    const code = await token.detectTransferRestriction(sender, recipient, transferValue)
    assert(code.eq(SUCCESS_CODE))
  })

  it('should ensure success code is 0', async () => {
    assert.equal(SUCCESS_CODE, 0)
  })
  
  it('should return success message for success code', async () => {
    const message = await token.messageForTransferRestriction(SUCCESS_CODE)
    assert.equal(SUCCESS_MESSAGE, message)
  })

  if('should deny token transfer from non-whitelisted sender', async () => {
    let revertedTransfer = false
    try {
      await token.transfer(owner, transferValue, { from: operator })
    } catch (err) {
      revertedTransfer = true
    }
    assert(revertedTransfer)
  })

  it('should detect restriction for transfer from non-whitelisted sender', async () => {
    const code = await token.detectTransferRestriction(operator, owner, transferValue)
    assert(code.eq(SEND_NOT_ALLOWED_CODE))
  })

  it('should return send-not-allowed error message for transfer from non-whitelisted sender error code', async () => {
    const message = await token.messageForTransferRestriction(SEND_NOT_ALLOWED_CODE)
    assert.equal(SEND_NOT_ALLOWED_ERROR, message)
  })
  
  it('should allow owner to whitelist a sending address', async () => {
    await token.addToSendAllowed(operator, { from: owner })
    const isWhitelisted = await token.sendAllowed(operator)
    assert.equal(isWhitelisted, true)
  })
  
  it('should allow token transfer from whitelisted sender', async () => {
    const senderBalanceBefore = await token.balanceOf(operator)
    const recipientBalanceBefore = await token.balanceOf(owner)
    await token.transfer(owner, transferValue, { from: operator })
    const senderBalanceAfter = await token.balanceOf(operator)
    const recipientBalanceAfter = await token.balanceOf(owner)
    assert.equal(senderBalanceAfter.valueOf(), senderBalanceBefore.minus(transferValue).valueOf())
    assert.equal(recipientBalanceAfter.valueOf(), recipientBalanceBefore.plus(transferValue).valueOf())
  })

  it('should allow owner to de-whitelist a sending address', async () => {
    await token.removeFromSendAllowed(operator, { from: owner })
    const isWhitelisted = await token.sendAllowed(operator)
    assert.equal(isWhitelisted, false)
  })


  it('should allow owner to de-whitelist a receiving address', async () => {
    await token.removeFromReceiveAllowed(operator, { from: owner })
    const isWhitelisted = await token.receiveAllowed(operator)
    assert.equal(isWhitelisted, false)
  })

  it('should allow owner to add an address to both whitelists', async () => {
    await token.addToBothSendAndReceiveAllowed(operator, { from: owner })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, true)
    assert.equal(isReceiveAllowed, true)
  })

  it('should allow owner to remove an address from both whitelists', async () => {
    await token.removeFromBothSendAndReceiveAllowed(operator, { from: owner })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, false)
    assert.equal(isReceiveAllowed, false)
  })

  it('should allow a manager to whitelist a sending address', async () => {
    await token.addToSendAllowed(operator, { from: manager })
    const isWhitelisted = await token.sendAllowed(operator)
    assert.equal(isWhitelisted, true)
  })

  it('should allow manager to de-whitelist a sending address', async () => {
    await token.removeFromSendAllowed(operator, { from: manager })
    const isWhitelisted = await token.sendAllowed(operator)
    assert.equal(isWhitelisted, false)
  })

  it('should allow manager to whitelist a receiving address', async () => {
    await token.addToReceiveAllowed(operator, { from: manager })
    const isWhitelisted = await token.receiveAllowed(operator)
    assert.equal(isWhitelisted, true)
  })

  it('should allow manager to de-whitelist a receiving address', async () => {
    await token.removeFromReceiveAllowed(operator, { from: manager })
    const isWhitelisted = await token.receiveAllowed(operator)
    assert.equal(isWhitelisted, false)
  })

  it('should allow manager to add an address to both whitelists', async () => {
    await token.addToBothSendAndReceiveAllowed(operator, { from: manager })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, true)
    assert.equal(isReceiveAllowed, true)
  })

  it('should allow manager to remove an address from both whitelists', async () => {
    await token.removeFromBothSendAndReceiveAllowed(operator, { from: manager })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, false)
    assert.equal(isReceiveAllowed, false)
  })

  it('should allow owner to remove a manager', async () => {
    await token.removeManager(manager, { from: owner })
    const isManager = await token.isManager({ from: manager })
    assert.equal(isManager, false)
  })
})
