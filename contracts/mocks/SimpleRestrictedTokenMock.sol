pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../token/ERC1404/SimpleRestrictedToken.sol";

contract SimpleRestrictedTokenMock is BasicTokenMock, SimpleRestrictedToken {
    constructor (address initialAccount, uint256 initialBalance)
        BasicTokenMock(initialAccount, initialBalance)
        public
    {

    }
}