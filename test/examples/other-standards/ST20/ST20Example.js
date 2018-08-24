const BigNumber = require('bignumber.js')
const hex2ascii = require('hex2ascii')
const ST20ExampleMock = artifacts.require('./mocks/ST20ExampleMock')

contract('ST20Example', ([sender, recipient, ...accounts]) => {
  const owner = sender
  const initialAccount = sender
  const transferValue = '100000000000000000'
  const initialBalance = '100000000000000000000'
  const tokenDetails = 'website:tokensoft.io'
  const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

  let token
  let tokenTotalSupply
  let SUCCESS_CODE
  let SUCCESS_MESSAGE
  let ZERO_ADDRESS_RESTRICTION_CODE
  let ZERO_ADDRESS_RESTRICTION_MESSAGE
  before(async () => {
    token = await ST20ExampleMock.new(
      initialAccount,
      initialBalance,
      tokenDetails
    )
    tokenTotalSupply = await token.totalSupply()
    SUCCESS_CODE = await token.SUCCESS_CODE()
    SUCCESS_MESSAGE = await token.SUCCESS_MESSAGE()
    ZERO_ADDRESS_RESTRICTION_CODE = await token.ZERO_ADDRESS_RESTRICTION_CODE()
    ZERO_ADDRESS_RESTRICTION_MESSAGE = await token.ZERO_ADDRESS_RESTRICTION_MESSAGE()
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

  it('should allow transfer between non-zero addresses', async () => {
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
  })

  it('should allow transferFrom between non-zero addresses (after approval)', async () => {
    await token.approve(sender, transferValue, { from: sender })
    await token.transferFrom(sender, recipient, transferValue, {
      from: sender
    })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
  })
  
  it('should deny transfer to the zero address', async () => {
    let transferReverted = false
    try {
      await token.transfer(ZERO_ADDRESS, transferValue, { from: sender })
    } catch (err) {
      transferReverted = true
    }
    assert(transferReverted)
  })

  it('should deny transferFrom to the zero address (after approval)', async () => {
    let transferReverted = false
    try {
      await token.approve(sender, transferValue, { from: sender })  
      await token.transferFrom(sender, ZERO_ADDRESS, transferValue, {
        from: sender
      })
    } catch (err) {
      transferReverted = true
    }
    assert(transferReverted)
  })

  it('should detect success for transfer between non-zero addresses', async () => {
    const code = await token.detectTransferRestriction(sender, recipient, transferValue)
    assert(code.eq(SUCCESS_CODE))
  })

  it('should detect zero address restriction for transfer to zero-address', async () => {
    const code = await token.detectTransferRestriction(sender, ZERO_ADDRESS, transferValue)
    assert(code.eq(ZERO_ADDRESS_RESTRICTION_CODE))
  })

  it('should return false for verifyTransfer call on transfer between non-zero addresses', async () => {
    const verifyTransferResult = await token.verifyTransfer(sender, ZERO_ADDRESS, transferValue)
    assert(verifyTransferResult === false)
  })

  it('should return true for verifyTransfer call on transfer to zero-address', async () => {
    const verifyTransferResult = await token.verifyTransfer(sender, recipient, transferValue)
    assert(verifyTransferResult === true)
  })

  it('should ensure success code is 0', async () => {
    assert.equal(SUCCESS_CODE, 0)
  })
  
  it('should return success message for success code', async () => {
    const message = await token.messageForTransferRestriction(SUCCESS_CODE)
    assert.equal(SUCCESS_MESSAGE, message)
  })

  it('should return restriction message for zero address restriction code', async () => {
    const message = await token.messageForTransferRestriction(ZERO_ADDRESS_RESTRICTION_CODE)
    assert.equal(ZERO_ADDRESS_RESTRICTION_MESSAGE, message)
  })

  it('should have tokenDetails set in the constructor', async () => {
    const _tokenDetails = await token.tokenDetails()
    assert.equal(tokenDetails, hex2ascii(_tokenDetails))
  })

  it('should allow owner to mint tokens to an address', async () => {
    const tokenTotalSupplyBefore = await token.totalSupply()
    await token.mint(recipient, transferValue, { from: owner })
    const recipientBalanceAfter = await token.balanceOf(recipient)
    const tokenTotalSupplyAfter = await token.totalSupply()
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
    assert(tokenTotalSupplyAfter.eq(tokenTotalSupplyBefore.plus(transferValue)))
  })
})