const IndivisibleTokenMock = artifacts.require('IndivisibleTokenMock')

contract('IndivisibleToken', ([owner, recipient, ...accounts]) => {
  const initialAccount = owner
  const transferValue = '1000000000000000000' // 1 token
  const initialBalance = '100000000000000000000'
  const decimals = 18

  let token
  let tokenTotalSupply
  let sender = owner
  let FRACTION_TRANSFER_CODE
  let FRACTION_TRANSFER_ERROR
  before(async () => {
    token = await IndivisibleTokenMock.new(initialAccount, initialBalance, decimals)
    tokenTotalSupply = await token.totalSupply()
    FRACTION_TRANSFER_CODE = await token.FRACTION_TRANSFER_CODE()
    FRACTION_TRANSFER_ERROR = await token.FRACTION_TRANSFER_ERROR()
  })

  let senderBalanceBefore
  let recipientBalanceBefore
  beforeEach(async () => {
    senderBalanceBefore = await token.balanceOf(sender)
    recipientBalanceBefore = await token.balanceOf(recipient)
  })

  it('should have a decimals value on the token contract', async () => {
    const _decimals = await token.decimals()
    assert(_decimals.eq(decimals))
  })

  it('should detect fractional transfer restriction', async () => {
    const transferValue = '1000000000000000001'
    const code = await token.detectTransferRestriction(sender, recipient, transferValue)
    assert(code.eq(FRACTION_TRANSFER_CODE))
  })

  it('should return fractional transfer error message', async () => {
    const message = await token.messageForTransferRestriction(FRACTION_TRANSFER_CODE)
    assert.equal(FRACTION_TRANSFER_ERROR, message)
  })

  it('should deny fractional transfers', async () => {
    const transferValue = '1000000000000000001'
    
    let transferReverted = false
    try {
      await token.transfer(recipient, transferValue, { from: sender })
    } catch (err) {
      transferReverted = true
    }

    assert(transferReverted)
  })

  it('should allow whole transfers', async () => {
    await token.transfer(recipient, transferValue, { from: sender })

    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
  })
})