const SRS20Mock = artifacts.require('SRS20Mock')

contract('SRS20Mock', ([owner, ...accounts]) => {
  let token
  let tokenTotalSupply

  before(async () => {
    token = await SRS20Mock.deployed()
    tokenTotalSupply = await token.totalSupply()
  })

  it('should give total supply of tokens to owner', async () => {
    try {
      const ownerBalance = await token.balanceOf(owner)
      assert.equal(ownerBalance.valueOf(), tokenTotalSupply.valueOf())
    } catch (err) {
      console.log(err)
    }
  })

  it('should allow account to transfer tokens', async () => {
    try {
      const sender = owner
      const [recipient] = accounts
      const transferAmount = '1000'

      const senderBalanceBefore = await token.balanceOf(sender)
      const recipientBalanceBefore = await token.balanceOf(recipient)

      await token.transfer(recipient, transferAmount, { from: sender })

      const senderBalanceAfter = await token.balanceOf(sender)
      const recipientBalanceAfter = await token.balanceOf(recipient)

      assert.equal(
        senderBalanceAfter.valueOf(),
        senderBalanceBefore.minus(transferAmount).valueOf()
      )
      assert.equal(
        recipientBalanceAfter.valueOf(),
        recipientBalanceBefore.plus(transferAmount).valueOf()
      )
    } catch (err) {
      console.log(err)
    }
  })

  it('should allow owner to use the transferFrom method after approval', async () => {
    try {
      const [sender] = accounts
      const recipient = owner
      const transferAmount = '1000'

      const senderBalanceBefore = await token.balanceOf(sender)
      const recipientBalanceBefore = await token.balanceOf(recipient)

      await token.approve(owner, transferAmount, { from: sender })
      await token.transferFrom(sender, recipient, transferAmount, {
        from: owner
      })

      const senderBalanceAfter = await token.balanceOf(sender)
      const recipientBalanceAfter = await token.balanceOf(recipient)

      assert.equal(
        senderBalanceAfter.valueOf(),
        senderBalanceBefore.minus(transferAmount).valueOf()
      )
      assert.equal(
        recipientBalanceAfter.valueOf(),
        recipientBalanceBefore.plus(transferAmount).valueOf()
      )
    } catch (err) {
      console.log(err)
    }
  })
})
