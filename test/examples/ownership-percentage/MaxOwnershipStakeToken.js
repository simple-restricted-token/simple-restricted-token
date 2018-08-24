const {BigNumber} = require('bignumber.js')
const MaxOwnershipStakeTokenMock = artifacts.require('MaxOwnershipStakeTokenMock')

contract('MaxOwnershipStakeToken', async ([owner, stakeholder, ...accounts]) => {
  const initialAccount = owner
  const transferValue  = '1000000000000000000' // 1%
  const initialBalance = '100000000000000000000'
  const maxPercentOwnershipTimesOneThousand = .03 * 1000 // 3%

  let token
  let tokenTotalSupply
  let sender = owner
  let recipient = stakeholder
  let MAX_OWNERSHIP_STAKE_CODE
  let MAX_OWNERSHIP_STAKE_ERROR
  before(async () => {
    token = await MaxOwnershipStakeTokenMock.new(initialAccount, initialBalance, maxPercentOwnershipTimesOneThousand)
    tokenTotalSupply = await token.totalSupply()
    MAX_OWNERSHIP_STAKE_CODE = await token.MAX_OWNERSHIP_STAKE_CODE()
    MAX_OWNERSHIP_STAKE_ERROR = await token.MAX_OWNERSHIP_STAKE_ERROR()
  })

  let senderBalanceBefore
  let recipientBalanceBefore
  beforeEach(async () => {
    senderBalanceBefore = await token.balanceOf(sender)
    recipientBalanceBefore = await token.balanceOf(recipient)
  })

  it('should allow for stakeholders to hold ownership less than the maximum', async () => {
    const onePercentStake = transferValue
    await token.transfer(recipient, onePercentStake, { from: owner })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)

    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
  })

  it('should allow for stakeholders to hold ownership equal to the maximum', async () => {
    const twoPercentStake = new BigNumber(transferValue).times(2).toString()
    await token.transfer(recipient, twoPercentStake, { from: owner })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)

    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(twoPercentStake)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(twoPercentStake)))
  })

  it('should detect restriction for transfer that increases account stake above maximum', async () => {
    const code = await token.detectTransferRestriction(sender, recipient, transferValue)
    assert(code.eq(MAX_OWNERSHIP_STAKE_CODE))
  })

  it('should return max ownership stake error message for max ownership stake error code', async () => {
    const message = await token.messageForTransferRestriction(MAX_OWNERSHIP_STAKE_CODE)
    assert.equal( MAX_OWNERSHIP_STAKE_ERROR, message)
  })

  it('should revert if transfer would give an account greater than the maximum ownership stake allowed', async () => {
    let transferReverted = false
    try {
      await token.transfer(recipient, transferValue, { from: owner })
    } catch (err) {
      transferReverted = true
    }

    assert(transferReverted)
  })

  it('should allow owner to change the max ownership stake', async () => {
    await token.changeMaximumPercentOwnership(.04 * 1000) // 4%
    await token.transfer(recipient, transferValue, { from: owner })

    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
  })
})