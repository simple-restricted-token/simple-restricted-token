pragma solidity ^0.4.24;
import "./MessagedSRS20.sol";
import "zeppelin-solidity/contracts/access/Whitelist.sol";

contract BasicWhitelistToken is MessagedSRS20, Whitelist {
    uint public nonWhitelistCode = 2; // default error code
    
    constructor (uint _nonWhiteListCode) public {
        if (_nonWhiteListCode > 1) {
            nonWhitelistCode = _nonWhiteListCode;
        }
        messagesAndCodes.addMessage(
            nonWhitelistCode,
            "ILLEGAL_TRANSFER_TO_NON_WHITELISTED_ADDRESS"
        );
    }

    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint restrictionCode)
    {
        if (!whitelist(to)) {
            restrictionCode = nonWhitelistCode; // illegal transfer outside of whitelist
        } else {
            restrictionCode = SUCCESS_CODE; // successful transfer (required)
        }
    }
}