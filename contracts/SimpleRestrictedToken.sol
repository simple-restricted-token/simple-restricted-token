pragma solidity ^0.4.24;
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

/// @title Reference implementation for the SRS-20 token
/// @author TokenSoft Inc
/// @dev Inherit from this contract to implement your own SRS-20 token
contract SimpleRestrictedToken is StandardToken {
    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint restrictionCode)
    {
        restrictionCode = 0;
    }
        
    /// @notice Returns a human-readable message for a given restriction code
    /// @param restrictionCode Identifier for looking up a message
    /// @return Text showing the restriction's reasoning
    function messageForTransferRestriction (uint restrictionCode)
        public
        view
        returns (string message)
    {
        if (restrictionCode == 0) {
            message = "SUCCESS";
        }
    }
    
    function transfer (address to, uint value)
        public
        returns (bool success)
    {
        require(detectTransferRestriction(msg.sender, to, value) == 0);
        success = super.transfer(to, value);
    }

    function transferFrom (address from, address to, uint value)
        public
        returns (bool success)
    {
        require(detectTransferRestriction(from, to, value) == 0);
        success = super.transferFrom(from, to, value);
    }
}