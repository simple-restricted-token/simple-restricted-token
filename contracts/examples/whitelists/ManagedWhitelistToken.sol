pragma solidity ^0.4.24;
import "./ManagedWhitelist.sol";
import "../../token/SRS20/MessagedSRS20.sol";

contract ManagedWhitelistToken is MessagedSRS20, ManagedWhitelist {
    uint8 public sendNotAllowedCode = 1;
    uint8 public receiveNotAllowedCode = 2;
    
    constructor (uint8 _sendNotAllowedCode, uint8 _receiveNotAllowedCode) public {
        if (_sendNotAllowedCode > 0) {
            sendNotAllowedCode = _sendNotAllowedCode;
        }
        if (_receiveNotAllowedCode > 0) {
            receiveNotAllowedCode = _receiveNotAllowedCode;
        }
        messagesAndCodes.addMessage(
            sendNotAllowedCode,
            "ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED"
        );
        messagesAndCodes.addMessage(
            receiveNotAllowedCode,
            "ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED"
        );
    }

    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint8 restrictionCode)
    {
        if (!sendAllowed[from]) {
            restrictionCode = sendNotAllowedCode; // sender address not whitelisted
        } else if (!receiveAllowed[to]) {
            restrictionCode = receiveNotAllowedCode; // receiver address not whitelisted
        } else {
            restrictionCode = SUCCESS_CODE; // successful transfer (required)
        }
    }
}