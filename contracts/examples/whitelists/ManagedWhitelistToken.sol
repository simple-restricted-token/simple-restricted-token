pragma solidity ^0.4.24;
import "./ManagedWhitelist.sol";
import "../../token/SRS20/MessagedSRS20.sol";

contract ManagedWhitelistToken is MessagedSRS20, ManagedWhitelist {
    uint8 public SEND_NOT_ALLOWED_CODE = 1;
    uint8 public RECEIVE_NOT_ALLOWED_CODE = 2;
    
    constructor (uint8 sendNotAllowedCode, uint8 receiveNotAllowedCode) public {
        if (sendNotAllowedCode > 0) {
            SEND_NOT_ALLOWED_CODE = sendNotAllowedCode;
        }
        if (receiveNotAllowedCode > 0) {
            RECEIVE_NOT_ALLOWED_CODE = receiveNotAllowedCode;
        }
        messagesAndCodes.addMessage(
            SEND_NOT_ALLOWED_CODE,
            "ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED"
        );
        messagesAndCodes.addMessage(
            RECEIVE_NOT_ALLOWED_CODE,
            "ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED"
        );
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