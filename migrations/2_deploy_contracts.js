var MessagesAndCodes = artifacts.require('./libraries/MessagesAndCodes')
var SimpleRestrictedTokenMock = artifacts.require('./mocks/SimpleRestrictedTokenMock')
var BasicWhitelistTokenMock = artifacts.require('./mocks/BasicWhitelistTokenMock')
var ManagedWhitelistTokenMock = artifacts.require('./mocks/ManagedWhitelistTokenMock')

module.exports = function (deployer) {
  deployer.then(async () => {
    try {
      // deploy and link MessagesAndCodes lib for MessagedSRS20's
      await deployer.deploy(MessagesAndCodes)
      await deployer.link(MessagesAndCodes, [
        BasicWhitelistTokenMock,
        ManagedWhitelistTokenMock
      ])
    } catch (err) {
      console.log(('Failed to Deploy Contracts', err))
    }
  })
}
