pragma solidity ^0.4.24;
import "../../../token/ST20/ST20Token.sol"; 
import "../../../token/ERC1404/MessagedERC1404.sol";
 
/// @title Example of an ST-20 compliant token built on top of ERC-1404
contract ST20Example is ST20Token, MessagedERC1404 {
    uint8 public ZERO_ADDRESS_RESTRICTION_CODE;
    string public constant ZERO_ADDRESS_RESTRICTION_MESSAGE = "ILLEGAL_TRANSFER_TO_ZERO_ADDRESS";
    
    constructor (bytes32 _tokenDetails) {
        tokenDetails = _tokenDetails;
        ZERO_ADDRESS_RESTRICTION_CODE = messagesAndCodes.autoAddMessage(ZERO_ADDRESS_RESTRICTION_MESSAGE);
    }

    function detectTransferRestriction (address from, address to, uint256 value)
        public view returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE; // success
        if (to == address(0x0)) {
            restrictionCode = ZERO_ADDRESS_RESTRICTION_CODE; // illegal transfer to zero address
        }
    }
}