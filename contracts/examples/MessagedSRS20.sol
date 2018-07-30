pragma solidity ^0.4.24;
import "../SimpleRestrictedToken.sol";
import "../libraries/MessagesAndCodes.sol";

contract MessagedSRS20 is SimpleRestrictedToken {
    using MessagesAndCodes for MessagesAndCodes.Data;
    MessagesAndCodes.Data internal messagesAndCodes;

    constructor () public {
        messagesAndCodes.addMessage(0, "SUCCESS");
    }

    function messageForTransferRestriction (uint restrictionCode)
        public
        view
        returns (string message)
    {
        message = messagesAndCodes.messages[restrictionCode];
    }
}
