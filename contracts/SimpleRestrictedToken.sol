pragma solidity ^0.4.24;
import "./SRS20.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

/// @title Reference implementation for the SRS-20 token
/// @author TokenSoft Inc
/// @dev Inherit from this contract to implement your own SRS-20 token
contract SimpleRestrictedToken is SRS20, StandardToken {
    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint restrictionCode)
    {
        restrictionCode = 1;
    }
        
    function messageForTransferRestriction (uint restrictionCode)
        public
        view
        returns (string message)
    {
        if (restrictionCode == 1) {
            message = "SUCCESS";
        }
    }
    
    function transfer (address to, uint value)
        public
        returns (bool success)
    {
        require(detectTransferRestriction(msg.sender, to, value) == 1);
        success = super.transfer(to, value);
    }

    function transferFrom (address from, address to, uint value)
        public
        returns (bool success)
    {
        require(detectTransferRestriction(from, to, value) == 1);
        success = super.transferFrom(from, to, value);
    }
}