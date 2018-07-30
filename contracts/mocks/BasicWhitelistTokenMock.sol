pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/BasicWhitelistToken.sol";

contract BasicWhitelistTokenMock is BasicTokenMock, BasicWhitelistToken {
    constructor (address initialAccount, uint256 initialBalance)
      BasicTokenMock(initialAccount, initialBalance)
      public
    {
        addAddressToWhitelist(initialAccount);
    }
}