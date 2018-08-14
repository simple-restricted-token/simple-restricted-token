pragma solidity ^0.4.24;
import "./MessagesAndCodes.sol";
import "./SimpleRestrictedToken.sol";

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
