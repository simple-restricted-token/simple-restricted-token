pragma solidity ^0.4.24;
import "../../token/ERC1404/MessagedERC1404.sol";
import "zeppelin-solidity/contracts/access/Whitelist.sol";

contract BasicWhitelistToken is MessagedERC1404, Whitelist {
    uint8 public NON_WHITELIST_CODE;
    string public constant NON_WHITELIST_ERROR = "ILLEGAL_TRANSFER_TO_NON_WHITELISTED_ADDRESS";
    
    constructor () public {
        NON_WHITELIST_CODE = messagesAndCodes.autoAddMessage(NON_WHITELIST_ERROR);
    }

    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint8 restrictionCode)
    {
        if (!whitelist(to)) {
            restrictionCode = NON_WHITELIST_CODE; // illegal transfer outside of whitelist
        } else {
            restrictionCode = SUCCESS_CODE; // successful transfer (required)
        }
    }
}