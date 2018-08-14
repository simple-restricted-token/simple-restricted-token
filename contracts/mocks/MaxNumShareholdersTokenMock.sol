pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/shareholder-rules/MaxNumShareholdersToken.sol";

contract MaxNumShareholdersTokenMock is MaxNumShareholdersToken, BasicTokenMock {
    constructor (address initialAccount, uint256 initialBalance, uint256 _maxNumShareholders)
        MaxNumShareholdersToken(_maxNumShareholders)
        BasicTokenMock(initialAccount, initialBalance)
        public
    {

    }
}