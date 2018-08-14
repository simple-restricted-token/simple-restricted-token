const BasicWhitelistTokenMock = artifacts.require('BasicWhitelistTokenMock')

contract('BasicWhitelistToken', ([owner, operator, ...accounts]) => {
  const initialAccount = owner
  const transferValue = '100000000000000000'
  const initialBalance = '100000000000000000000'

  let token
  let tokenTotalSupply
  let sender = owner
  let recipient = operator
  let SUCCESS_CODE
  let SUCCESS_MESSAGE
  let NON_WHITELIST_CODE
  let NON_WHITELIST_ERROR
  before(async () => {
    token = await BasicWhitelistTokenMock.new(initialAccount, initialBalance)
    tokenTotalSupply = await token.totalSupply()
    SUCCESS_CODE = await token.SUCCESS_CODE()
    SUCCESS_MESSAGE = await token.SUCCESS_MESSAGE()
    NON_WHITELIST_CODE = await token.NON_WHITELIST_CODE()
    NON_WHITELIST_ERROR = await token.NON_WHITELIST_ERROR()
  })

  let senderBalanceBefore
  let recipientBalanceBefore
  beforeEach(async () => {
    senderBalanceBefore = await token.balanceOf(sender)
    recipientBalanceBefore = await token.balanceOf(recipient)
  })

  it('should revert transfers between non-whitelisted accounts', async () => {
    let revertedTransfer = false
    try {
      await token.transfer(recipient, transferValue, { from: sender })
    } catch (err) {
      revertedTransfer = true
    }

    assert(revertedTransfer)
  })

  it('should revert use of transferFrom between non-whitelisted accounts', async () => {
    let revertedTransfer = false
    try {
      await token.approve(owner, transferValue, { from: sender })
      await token.transferFrom(sender, recipient, transferValue, { from: owner })
    } catch (err) {
      revertedTransfer = true
    }

    assert(revertedTransfer)
  })

  it('should detect restriction for transfer between non-whitelisted accounts', async () => {
    const code = await token.detectTransferRestriction(sender, recipient, transferValue)
    assert(code.eq(NON_WHITELIST_CODE))
  })
  
  it('should return non-whitelisted error message for whitelist error code', async () => {
    const message = await token.messageForTransferRestriction(NON_WHITELIST_CODE)
    assert.equal(NON_WHITELIST_ERROR, message)
  })

  it('should allow contract owner to whitelist an account', async () => {
    await token.addAddressToWhitelist(operator, { from: owner })
    const operatorIsWhitelisted = await token.whitelist(operator)
    assert(operatorIsWhitelisted)
  })

  it('should allow transfer between whitelisted accounts', async () => {
    await token.transfer(recipient, transferValue, { from: sender })
    
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)

    assert.equal(
      senderBalanceAfter.valueOf(),
      senderBalanceBefore.minus(transferValue).valueOf()
    )
    assert.equal(
      recipientBalanceAfter.valueOf(),
      recipientBalanceBefore.plus(transferValue).valueOf()
    )
  })

  it('should allow use of transferFrom betwen whitelisted accounts', async () => {
    await token.approve(owner, transferValue, { from: sender })
    await token.transferFrom(sender, recipient, transferValue, { from: owner })

    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)

    assert.equal(
      senderBalanceAfter.valueOf(),
      senderBalanceBefore.minus(transferValue).valueOf()
    )
    assert.equal(
      recipientBalanceAfter.valueOf(),
      recipientBalanceBefore.plus(transferValue).valueOf()
    )
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
})
