pragma solidity 0.4.24;
import "../SimpleRestrictedToken.sol";
import "zeppelin-solidity/contracts/access/Whitelist.sol";

contract BasicWhitelistToken is SimpleRestrictedToken, Whitelist {
  function detectTransferRestriction (address from, address to, uint value)
    public
    constant
    returns (uint restrictionCode)
  {
    if (whitelist(to)) {
      restrictionCode = 1; // illegal transfer outside of whitelist
    } else {
      restrictionCode = 0; // successful transfer (required)
    }
  }

  function messageForTransferRestriction (uint restrictionCode)
    public
    view
    return (string message)
  {
    if (restrictionCode == 0) {
      message = "SUCCESS"; // required
    } else if (restrictionCode == 1) {
      message = "ILLEGAL_TRANSFER_TO_NON_WHITELISTED_ADDRESS";
    } else {
      message = "UNKNOWN"; // fallback
    }
  }
}