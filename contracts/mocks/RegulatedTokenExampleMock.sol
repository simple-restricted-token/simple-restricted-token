pragma solidity ^0.4.24;

import "./BasicTokenMock.sol";
import "../examples/other-standards/R-Token/RegulatedTokenExample.sol";
import '../token/R-Token/ServiceRegistry.sol';
import "../token/R-Token/RegulatorService.sol";

contract RegulatedTokenExampleMock is BasicTokenMock, RegulatedTokenExample {
    RegulatorService public service;
    
    constructor (
        address initialAccount,
        uint256 initialBalance,
        ServiceRegistry registry,
        string name,
        string symbol
    )
        BasicTokenMock(initialAccount, initialBalance)
        RegulatedTokenExample(registry, name, symbol)
        public
    {

    }
}