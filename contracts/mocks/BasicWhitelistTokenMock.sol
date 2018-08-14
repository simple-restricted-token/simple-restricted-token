pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/whitelists/BasicWhitelistToken.sol";

contract BasicWhitelistTokenMock is BasicTokenMock, BasicWhitelistToken {
    constructor (address initialAccount, uint256 initialBalance, uint8 nonWhitelistCode)
        BasicTokenMock(initialAccount, initialBalance)
        BasicWhitelistToken(nonWhitelistCode)
        public
    {
        addAddressToWhitelist(initialAccount);
    }
}