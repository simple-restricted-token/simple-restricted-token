pragma solidity ^0.4.24;
import "./MessagedSRS20.sol";
import "./ManagedWhitelist.sol";

contract ManagedWhitelistToken is MessagedSRS20, ManagedWhitelist {
    uint public sendNotAllowedCode = 2;
    uint public receiveNotAllowedCode = 3;
    
    constructor (uint _sendNotAllowedCode, uint _receiveNotAllowedCode) public {
        if (_sendNotAllowedCode > 1) {
            sendNotAllowedCode = _sendNotAllowedCode;
        }
        if (_receiveNotAllowedCode > 1) {
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
        returns (uint restrictionCode)
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