pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/whitelists/ManagedWhitelistToken.sol";

contract ManagedWhitelistTokenMock is BasicTokenMock, ManagedWhitelistToken {
    constructor (address initialAccount, uint256 initialBalance)
        BasicTokenMock(initialAccount, initialBalance)
        public
    {
        addToBothSendAndReceiveAllowed(initialAccount);
    }
}