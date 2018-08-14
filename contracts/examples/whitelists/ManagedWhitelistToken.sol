pragma solidity ^0.4.24;
import "./ManagedWhitelist.sol";
import "../../token/SRS20/MessagedSRS20.sol";

contract ManagedWhitelistToken is MessagedSRS20, ManagedWhitelist {
    uint8 public SEND_NOT_ALLOWED_CODE;
    uint8 public RECEIVE_NOT_ALLOWED_CODE;
    string public constant SEND_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED";
    string public constant RECEIVE_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED";
    
    constructor () public {
        SEND_NOT_ALLOWED_CODE = messagesAndCodes.autoAddMessage(SEND_NOT_ALLOWED_ERROR);
        RECEIVE_NOT_ALLOWED_CODE = messagesAndCodes.autoAddMessage(RECEIVE_NOT_ALLOWED_ERROR);
    }

    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint8 restrictionCode)
    {
        if (!sendAllowed[from]) {
            restrictionCode = SEND_NOT_ALLOWED_CODE; // sender address not whitelisted
        } else if (!receiveAllowed[to]) {
            restrictionCode = RECEIVE_NOT_ALLOWED_CODE; // receiver address not whitelisted
        } else {
            restrictionCode = SUCCESS_CODE; // successful transfer (required)
        }
    }
}