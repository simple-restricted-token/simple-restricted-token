pragma solidity ^0.4.24;
import "../SimpleRestrictedToken.sol";
import "../libraries/MessagesAndCodes.sol";

contract MessagedSRS20 is SimpleRestrictedToken {
    using MessagesAndCodes for MessagesAndCodes.Data;
    MessagesAndCodes.Data internal messagesAndCodes;

    constructor () public {
        messagesAndCodes.addMessage(0, "UNKNOWN"); // fallback message
        messagesAndCodes.addMessage(1, "SUCCESS"); // required 'SUCCESS' message
    }

    function messageForTransferRestriction (uint restrictionCode)
        public
        view
        returns (string message)
    {
        message = messagesAndCodes.messages[restrictionCode];
    }
}
