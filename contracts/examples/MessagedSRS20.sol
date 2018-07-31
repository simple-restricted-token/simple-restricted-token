pragma solidity ^0.4.24;
import "../SimpleRestrictedToken.sol";
import "../libraries/MessagesAndCodes.sol";

contract MessagedSRS20 is SimpleRestrictedToken {
    uint public constant UNKNOWN_CODE = 0;
    uint public constant SUCCESS_CODE = 1;

    using MessagesAndCodes for MessagesAndCodes.Data;
    MessagesAndCodes.Data internal messagesAndCodes;

    constructor () public {
        messagesAndCodes.addMessage(UNKNOWN_CODE, "UNKNOWN"); // fallback message
        messagesAndCodes.addMessage(SUCCESS_CODE, "SUCCESS"); // required 'SUCCESS' message
    }

    function messageForTransferRestriction (uint restrictionCode)
        public
        view
        returns (string message)
    {
        message = messagesAndCodes.messages[restrictionCode];
    }
}
