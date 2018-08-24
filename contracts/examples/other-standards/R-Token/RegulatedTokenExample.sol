
pragma solidity ^0.4.18;

import "../../../token/SRS20/SRS20.sol";
import "../../../token/R-Token/RegulatedToken.sol";
import '../../../token/R-Token/ServiceRegistry.sol';

contract RegulatedTokenExample is SRS20, RegulatedToken {
    function RegulatedTokenExample(ServiceRegistry _registry, string _name, string _symbol) public
        RegulatedToken(_registry, _name, _symbol)
    {

    }

   /**
    * @notice Implementing detectTransferRestriction makes this token SRS-20 compatible
    * 
    * @dev Notice in the call to _service.check(), the 2nd argument is address 0.
    *      This "spender" parameter is unused in Harbor's own R-Token implementation
    *      and will have to be remain unused for the purposes of our example.
    *
    * @param from The address of the sender
    * @param to The address of the receiver
    * @param value The number of tokens to transfer
    *
    * @return A code that is associated with the reason for a failed check
    */
    function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8) {
        return _service().check(this, address(0), from, to, value);
    }

   /**
    * @notice Implementing messageForTransferRestriction makes this token SRS-20 compatible
    *
    * @dev The RegulatorService contract must implement the function messageforReason in this implementation
    * 
    * @param reason The restrictionCode returned from the service check
    *
    * @return The human-readable mesage string
    */
    function messageForTransferRestriction (uint8 reason) public view returns (string) {
        return _service().messageForReason(reason);
    }
}