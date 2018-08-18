pragma solidity ^0.4.24;
import "./IST20.sol";
import "../SRS20/SimpleRestrictedToken";

/// @title Reference implementation for ST-20 compliant token on top of SRS-20
/// @author TokenSoft Inc
contract ST20Token is IST20, SimpleRestrictedToken {
    function verifyTransfer (
        address _from,
        address _to,
        uint256 _amount
    )
        public
        view
        returns (bool success)
    {
        success = detectTransferRestriction(_from, _to, _amount) == 0;
    }
}