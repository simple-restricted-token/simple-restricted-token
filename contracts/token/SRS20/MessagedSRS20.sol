pragma solidity ^0.4.24;
import "./MessagesAndCodes.sol";
import "./SimpleRestrictedToken.sol";

/// @title SRS-20 implementation with built-in message and code management solution
/// @author TokenSoft Inc
/// @dev Inherit from this contract to implement your own SRS-20 token
contract MessagedSRS20 is SimpleRestrictedToken {
    using MessagesAndCodes for MessagesAndCodes.Data;
    MessagesAndCodes.Data internal messagesAndCodes;

    constructor () public {
        messagesAndCodes.addMessage(SUCCESS_CODE, SUCCESS_MESSAGE);
    }

    function messageForTransferRestriction (uint8 restrictionCode)
        public
        view
        returns (string message)
    {
        message = messagesAndCodes.messages[restrictionCode];
    }
}
