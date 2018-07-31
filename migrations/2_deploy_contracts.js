var SRS20Mock = artifacts.require('./mocks/SRS20Mock')
var MessagedSRS20Mock = artifacts.require('./mocks/MessagedSRS20Mock')
var BasicWhitelistTokenMock = artifacts.require(
  './mocks/BasicWhitelistTokenMock'
)
var ManagedWhitelistTokenMock = artifacts.require(
  './mocks/ManagedWhitelistTokenMock'
)
var MessagesAndCodes = artifacts.require('./libraries/MessagesAndCodes')

const initialBalance = '100000000000000000000' // 100 tokens when decimals is 18

module.exports = function(deployer, network, [initialAccount, ...accounts]) {
  deployer.then(async () => {
    try {
      // deploy and link MessagesAndCodes lib
      await deployer.deploy(MessagesAndCodes)
      await deployer.link(MessagesAndCodes, [
        MessagedSRS20Mock,
        BasicWhitelistTokenMock,
        ManagedWhitelistTokenMock
      ])

      // deploy SRS20Mock for tests
      await deployer.deploy(SRS20Mock, initialAccount, initialBalance)

      // deploy MessagedSRC20Mock for tests
      await deployer.deploy(MessagedSRS20Mock, initialAccount, initialBalance)

      // deploy BasicWhitelistTokenMock for tests
      await deployer.deploy(
        BasicWhitelistTokenMock,
        initialAccount,
        initialBalance,
        2 // nonWhitelistCode
      )

      // deploy ManagedWhitelistTokenMock for tests
      await deployer.deploy(
        ManagedWhitelistTokenMock,
        initialAccount,
        initialBalance,
        2, // sendNotAllowedCode
        3 // receiveNotAllowedCode
      )
    } catch (err) {
      console.log(('Failed to Deploy Contracts', err))
    }
  })
}
