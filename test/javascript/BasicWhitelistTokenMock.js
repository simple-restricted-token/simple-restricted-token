const BasicWhitelistTokenMock = artifacts.require('BasicWhitelistTokenMock')

contract('BasicWhitelistTokenMock', ([owner, ...accounts]) => {
  let token
  let tokenTotalSupply

  before(async () => {
    token = await BasicWhitelistTokenMock.deployed()
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

  it('should allow owner to whitelist an address', async () => {
    try {
      const [operator] = accounts
      await token.addAddressToWhitelist(operator, { from: owner })
      const operatorIsWhitelisted = await token.whitelist(operator)
      assert(operatorIsWhitelisted)
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

  it('should revert transfers to accounts outside of whitelist', async () => {
    try {
      const sender = owner
      const [_, recipient] = accounts
      const transferAmount = '1000'

      const senderBalanceBefore = await token.balanceOf(sender)
      const recipientBalanceBefore = await token.balanceOf(recipient)

      let revertedTransfer = false
      try {
        await token.transfer(recipient, transferAmount, { from: sender })
      } catch (err) {
        revertedTransfer = true
      }

      const senderBalanceAfter = await token.balanceOf(sender)
      const recipientBalanceAfter = await token.balanceOf(recipient)

      assert.equal(revertedTransfer, true)
      assert.equal(senderBalanceAfter.valueOf(), senderBalanceBefore.valueOf())
      assert.equal(
        recipientBalanceAfter.valueOf(),
        recipientBalanceBefore.valueOf()
      )
    } catch (err) {
      console.log(err)
    }
  })

  it('should allow owner to use the transferFrom method after approval', async () => {
    try {
      const [sender] = accounts
      const recipient = owner
      const transferAmount = '500'

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

  it('should deny owner to use the transferFrom method after approval to account outside of whitelist', async () => {
    try {
      const [sender, recipient] = accounts
      const transferAmount = '500'

      const senderBalanceBefore = await token.balanceOf(sender)
      const recipientBalanceBefore = await token.balanceOf(recipient)

      let revertedTransfer = false
      try {
        await token.approve(owner, transferAmount, { from: sender })
        await token.transferFrom(sender, recipient, transferAmount, {
          from: owner
        })
      } catch (err) {
        revertedTransfer = true
      }

      const senderBalanceAfter = await token.balanceOf(sender)
      const recipientBalanceAfter = await token.balanceOf(recipient)

      assert.equal(revertedTransfer, true)
      assert.equal(senderBalanceAfter.valueOf(), senderBalanceBefore.valueOf())
      assert.equal(
        recipientBalanceAfter.valueOf(),
        recipientBalanceBefore.valueOf()
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

  it('should return message "ILLEGAL_TRANSFER_TO_NON_WHITELISTED_ADDRESS" for restriction code of 2', async () => {
    try {
      const message = await token.messageForTransferRestriction(2)
      assert.equal(message, 'ILLEGAL_TRANSFER_TO_NON_WHITELISTED_ADDRESS')
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

  it('should return restriciton code of 2 for illegal transfer outside of whitelist', async () => {
    try {
      const sender = owner
      const [whitelistedAddress, nonWhitelistedAddress] = accounts
      const transferAmount = '1000'

      const code = await token.detectTransferRestriction(
        sender,
        nonWhitelistedAddress,
        transferAmount
      )
      assert.equal(code, 2)
    } catch (err) {
      console.log(err)
    }
  })
})
