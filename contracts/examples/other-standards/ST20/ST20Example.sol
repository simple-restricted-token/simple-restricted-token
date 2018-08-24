pragma solidity ^0.4.24;
import "../../../token/ST20/ST20Token.sol"; 
import "../../../token/SRS20/MessagedSRS20.sol";
 
/// @title Example of an ST-20 compliant token built on top of SRS-20
/// @author TokenSoft Inc
contract ST20Example is ST20Token, MessagedSRS20 {
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