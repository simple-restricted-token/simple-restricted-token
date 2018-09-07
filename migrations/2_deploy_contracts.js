var MessagesAndCodes = artifacts.require('./libraries/MessagesAndCodes')
var IndivisibleTokenMock = artifacts.require('./mocks/IndivisibleTokenMock')
var BasicWhitelistTokenMock = artifacts.require('./mocks/BasicWhitelistTokenMock')
var ManagedWhitelistTokenMock = artifacts.require('./mocks/ManagedWhitelistTokenMock')
var MaxOwnershipStakeTokenMock = artifacts.require('./mocks/MaxOwnershipStakeTokenMock')
var MaxNumShareholdersTokenMock = artifacts.require('./mocks/MaxNumShareholdersTokenMock')
var IndividualOwnershipStakeTokenMock = artifacts.require('./mocks/IndividualOwnershipStakeTokenMock')
var ST20ExampleMock = artifacts.require('./mocks/ST20ExampleMock')

module.exports = function (deployer) {
  deployer.then(async () => {
    try {
      // deploy and link MessagesAndCodes lib for MessagedSRS20's
      await deployer.deploy(MessagesAndCodes)
      await deployer.link(MessagesAndCodes, [
        IndivisibleTokenMock,
        BasicWhitelistTokenMock,
        ManagedWhitelistTokenMock,
        MaxOwnershipStakeTokenMock,
        MaxNumShareholdersTokenMock,
        IndividualOwnershipStakeTokenMock,
        ST20ExampleMock
      ])
    } catch (err) {
      console.log(('Failed to Deploy Contracts', err))
    }
  })
}
