pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/divisibility/IndivisibleToken.sol";

contract IndivisibleTokenMock is BasicTokenMock, IndivisibleToken {
    constructor (address initialAccount, uint256 initialBalance, uint8 decimals)
        BasicTokenMock(initialAccount, initialBalance)
        IndivisibleToken(decimals)
        public
    {

    }
}
