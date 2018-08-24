const ServiceRegistry = artifacts.require('./token/R-Token/ServiceRegistry')
const RegulatorServiceExample = artifacts.require('./examples/other-standards/R-Token/RegulatorServiceExample')
const RegulatedTokenExampleMock = artifacts.require('./mocks/RegulatedTokenExampleMock')

contract('RegulatedTokenExample', ([sender, recipient, ...accounts]) => {
  const owner = sender
  const initialAccount = sender
  const transferValue = '100000000000000000'
  const initialBalance = '100000000000000000000'
  
  const CHECK_SUCCESS = 0
  const SUCCESS_MESSAGE = 'Success'
  const CHECK_ELOCKED = 1
  const ELOCKED_MESSAGE = 'Token is locked'
  const CHECK_EDIVIS = 2
  const EDIVIS_MESSAGE = 'Token can not trade partial amounts'
  const CHECK_ESEND = 3
  const ESEND_MESSAGE = 'Sender is not allowed to send the token'
  const CHECK_ERECV = 4
  const ERECV_MESSAGE = 'Receiver is not allowed to receive the token'
  
  const PERM_SEND = 0x1
  const PERM_RECEIVE = 0x2

  let token
  let service
  let registry
  let tokenTotalSupply
  before(async () => {
    service = await RegulatorServiceExample.new()
    registry = await ServiceRegistry.new(service.address)
    token = await RegulatedTokenExampleMock.new(
      initialAccount,
      initialBalance,
      registry.address,
      'R-Token',
      'RTKN'
    )
    tokenTotalSupply = await token.totalSupply()
  })

  let senderBalanceBefore
  let recipientBalanceBefore
  beforeEach(async () => {
    senderBalanceBefore = await token.balanceOf(sender)
    recipientBalanceBefore = await token.balanceOf(recipient)
  })

  it('should mint total supply of tokens to initial account', async () => {
    const initialAccountBalance = await token.balanceOf(initialAccount)
    assert(initialAccountBalance.eq(tokenTotalSupply))
  })

  it('should handle CHECK_ESEND condition', async () => {
    const reason = await token.detectTransferRestriction(sender, recipient, transferValue)
    const message = await token.messageForTransferRestriction(reason)
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore))
    assert(reason.eq(CHECK_ESEND))
    assert.equal(message, ESEND_MESSAGE)
  })

  it('should handle CHECK_ERECV condition', async () => {
    await service.setPermission(token.address, sender, PERM_SEND) // approve sender
    const reason = await token.detectTransferRestriction(sender, recipient, transferValue)
    const message = await token.messageForTransferRestriction(reason)
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore))
    assert(reason.eq(CHECK_ERECV))
    assert.equal(message, ERECV_MESSAGE)
  })

  it('should handle CHECK_ECDIVIS condition', async () => {
    await service.setPermission(token.address, recipient, PERM_RECEIVE) // approve recipient
    const reason = await token.detectTransferRestriction(sender, recipient, transferValue)
    const message = await token.messageForTransferRestriction(reason)
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore))
    assert(reason.eq(CHECK_EDIVIS))
    assert.equal(message, EDIVIS_MESSAGE)
  })

  it('should allow for valid transfer', async () => {
    await service.setPartialTransfers(token.address, true) // enable partial transfers
    const reason = await token.detectTransferRestriction(sender, recipient, transferValue)
    const message = await token.messageForTransferRestriction(reason)
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(reason.eq(CHECK_SUCCESS))
    assert.equal(message, SUCCESS_MESSAGE)
    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
  })

  it('should handle CHECK_ELOCKED condition', async () => {
    await service.setLocked(token.address, true) // lock token transfers
    const reason = await token.detectTransferRestriction(sender, recipient, transferValue)
    const message = await token.messageForTransferRestriction(reason)
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore))
    assert(reason.eq(CHECK_ELOCKED))
    assert.equal(message, ELOCKED_MESSAGE)
  })
})