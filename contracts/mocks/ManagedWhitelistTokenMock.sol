pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/ManagedWhitelistToken.sol";

contract ManagedWhitelistTokenMock is BasicTokenMock, ManagedWhitelistToken {
    constructor (
      address initialAccount,
      uint256 initialBalance,
      uint8 sendNotAllowedCode,
      uint8 receiveNotAllowedCode
    )
        BasicTokenMock(initialAccount, initialBalance)
        ManagedWhitelistToken(sendNotAllowedCode, receiveNotAllowedCode)
        public
    {
        addToSendAllowed(initialAccount);
        addToReceiveAllowed(initialAccount);
    }
}