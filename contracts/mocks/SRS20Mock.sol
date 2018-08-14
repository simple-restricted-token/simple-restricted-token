pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../token/SRS20/SimpleRestrictedToken.sol";

contract SRS20Mock is BasicTokenMock, SimpleRestrictedToken {
    constructor (address initialAccount, uint256 initialBalance)
      BasicTokenMock(initialAccount, initialBalance)
      public
    {

    }
}