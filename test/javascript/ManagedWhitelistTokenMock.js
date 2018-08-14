const ManagedWhitelistTokenMock = artifacts.require('ManagedWhitelistTokenMock')

contract('ManagedWhitelistTokenMock', ([owner, ...accounts]) => {
  let token
  let tokenTotalSupply

  before(async () => {
    token = await ManagedWhitelistTokenMock.deployed()
    tokenTotalSupply = await token.totalSupply()
    await token.addManager(accounts[1], { from: owner })
  })

  it('should give total supply of tokens to owner', async () => {
    const ownerBalance = await token.balanceOf(owner)
    assert.equal(ownerBalance.valueOf(), tokenTotalSupply.valueOf())
  })

  it('should allow owner to add a manager', async () => {
    const [manager] = accounts
    await token.addManager(manager, { from: owner })
    const isManager = await token.isManager({ from: manager })
    assert.equal(isManager, true)
  })

  it('should allow owner to remove a manager', async () => {
    const [manager] = accounts
    await token.removeManager(manager, { from: owner })
    const isManager = await token.isManager({ from: manager })
    assert.equal(isManager, false)
  })

  it('should allow owner to whitelist a sending address', async () => {
    const [_, sender] = accounts
    await token.addToSendAllowed(sender, { from: owner })
    const isWhitelisted = await token.sendAllowed(sender)
    assert.equal(isWhitelisted, true)
  })

  it('should allow owner to de-whitelist a sending address', async () => {
    const [_, sender] = accounts
    await token.removeFromSendAllowed(sender, { from: owner })
    const isWhitelisted = await token.sendAllowed(sender)
    assert.equal(isWhitelisted, false)
  })

  it('should allow owner to whitelist a receiving address', async () => {
    const [_, receiver] = accounts
    await token.addToReceiveAllowed(receiver, { from: owner })
    const isWhitelisted = await token.receiveAllowed(receiver)
    assert.equal(isWhitelisted, true)
  })

  it('should allow owner to de-whitelist a receiving address', async () => {
    const [_, receiver] = accounts
    await token.removeFromReceiveAllowed(receiver, { from: owner })
    const isWhitelisted = await token.receiveAllowed(receiver)
    assert.equal(isWhitelisted, false)
  })

  it('should allow owner to add an address to both whitelists', async () => {
    const [_, operator] = accounts
    await token.addToBothSendAndReceiveAllowed(operator, { from: owner })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, true)
    assert.equal(isReceiveAllowed, true)
  })

  it('should allow owner to remove an address from both whitelists', async () => {
    const [_, operator] = accounts
    await token.removeFromBothSendAndReceiveAllowed(operator, { from: owner })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, false)
    assert.equal(isReceiveAllowed, false)
  })

  it('should allow manager to whitelist a sending address', async () => {
    const [sender, manager] = accounts
    await token.addToSendAllowed(sender, { from: manager })
    const isWhitelisted = await token.sendAllowed(sender)
    assert.equal(isWhitelisted, true)
  })

  it('should allow manager to de-whitelist a sending address', async () => {
    const [sender, manager] = accounts
    await token.removeFromSendAllowed(sender, { from: manager })
    const isWhitelisted = await token.sendAllowed(sender)
    assert.equal(isWhitelisted, false)
  })

  it('should allow manager to whitelist a receiving address', async () => {
    const [receiver, manager] = accounts
    await token.addToReceiveAllowed(receiver, { from: manager })
    const isWhitelisted = await token.receiveAllowed(receiver)
    assert.equal(isWhitelisted, true)
  })

  it('should allow manager to de-whitelist a receiving address', async () => {
    const [receiver, manager] = accounts
    await token.removeFromReceiveAllowed(receiver, { from: manager })
    const isWhitelisted = await token.receiveAllowed(receiver)
    assert.equal(isWhitelisted, false)
  })

  it('should allow manager to add an address to both whitelists', async () => {
    const [operator, manager] = accounts
    await token.addToBothSendAndReceiveAllowed(operator, { from: manager })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, true)
    assert.equal(isReceiveAllowed, true)
  })

  it('should allow manager to remove an address from both whitelists', async () => {
    const [operator, manager] = accounts
    await token.removeFromBothSendAndReceiveAllowed(operator, { from: manager })
    const isSendAllowed = await token.sendAllowed(operator)
    const isReceiveAllowed = await token.receiveAllowed(operator)
    assert.equal(isSendAllowed, false)
    assert.equal(isReceiveAllowed, false)
  })

  // it('should allow a token transfer between two whitelisted addresses', async () => {
  //   const [sender, receiver] = accounts 
  // })

  it('should return message "SUCCESS" for restriction code of 1', async () => {
    const message = await token.messageForTransferRestriction(0)
    assert.equal(message, 'SUCCESS')
  })

  it('should return message "ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED" for restriction code of 2', async () => {
    const message = await token.messageForTransferRestriction(1)
    assert.equal(message, 'ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED')
  })

  it('should return message "ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED" for restriction code of 3', async () => {
    const message = await token.messageForTransferRestriction(2)
    assert.equal(message, 'ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED')
  })
})
