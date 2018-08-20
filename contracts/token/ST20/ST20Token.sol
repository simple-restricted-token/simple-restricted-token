pragma solidity ^0.4.24;
import "./IST20.sol";
import "../SRS20/SimpleRestrictedToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/// @title Reference implementation for ST-20 compliant token on top of SRS-20
/// @author TokenSoft Inc
contract ST20Token is IST20, SimpleRestrictedToken, Ownable {
    using SafeMath for uint256;
    
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

    function mint(
        address _investor,
        uint256 _amount
    )
        public
        onlyOwner
        returns (bool success)
    {
        require(_investor != 0);
        totalSupply_ = totalSupply_.add(_amount);
        balances[_investor] = balances[_investor].add(_amount);
        emit Transfer(address(0), _investor, _amount);
        success = true;
    }
}