pragma solidity ^0.4.24;
import "../../token/SRS20/MessagedSRS20.sol";
import "zeppelin-solidity/contracts/access/Whitelist.sol";

contract BasicWhitelistToken is MessagedSRS20, Whitelist {
    uint8 public nonWhitelistCode = 1; // default error code
    
    constructor (uint8 _nonWhiteListCode) public {
        if (_nonWhiteListCode > 0) {
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
        returns (uint8 restrictionCode)
    {
        if (!whitelist(to)) {
            restrictionCode = nonWhitelistCode; // illegal transfer outside of whitelist
        } else {
            restrictionCode = SUCCESS_CODE; // successful transfer (required)
        }
    }
}