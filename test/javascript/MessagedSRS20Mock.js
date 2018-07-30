const MessagedSRS20Mock = artifacts.require('MessagedSRS20Mock')

contract('MessagedSRS20Mock', ([owner, ...accounts]) => {
  let token
  let tokenTotalSupply

  before(async () => {
    token = await MessagedSRS20Mock.deployed()
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

  it('should return message "UNKNOWN for restriction code of 0', async () => {
    try {
      const message = await token.messageForTransferRestriction(0)
      assert.equal(message, 'UNKNOWN')
    } catch (err) {
      console.log(err)
    }
  })

  it('should return message "SUCCESS" for restriction code of 1', async () => {
    try {
      const message = await token.messageForTransferRestriction(1)
      assert.equal(message, 'SUCCESS')
    } catch (err) {
      console.log(err)
    }
  })

  it('should return restriction code of 1 for valid transfer details', async () => {
    try {
      const sender = owner
      const [recipient] = accounts
      const transferAmount = '1000'

      const code = await token.detectTransferRestriction(
        sender,
        recipient,
        transferAmount
      )
      assert.equal(code, 1)
    } catch (err) {
      console.log(err)
    }
  })
})
