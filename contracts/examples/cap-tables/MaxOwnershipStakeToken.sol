pragma solidity ^0.4.24;
import "../../token/SRS20/MessagedSRS20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/// @title SRS-20 that limits the ownership stake all accounts may hold
/// @author TokenSoft Inc
contract MaxOwnershipStakeToken is MessagedSRS20, Ownable {
    using SafeMath for uint256;
    uint8 public MAX_OWNERSHIP_STAKE_CODE;
    uint256 public maxPercentOwnershipTimesOneThousand;
    string public constant MAX_OWNERSHIP_STAKE_ERROR = "ILLEGAL_TRANSFER_MAXIMUM_OWNERSHIP_STAKE_REACHED_FOR_RECIPIENT";
    string public constant PERCENT_OUT_OF_BOUNDS_ERROR = "Maximum percent ownership times 1000 must be less than or equal to 1000";

    constructor (uint256 _maxPercentOwnershipTimesOneThousand) public {
        require(_maxPercentOwnershipTimesOneThousand <= 1000, PERCENT_OUT_OF_BOUNDS_ERROR);
        maxPercentOwnershipTimesOneThousand = _maxPercentOwnershipTimesOneThousand;
        MAX_OWNERSHIP_STAKE_CODE = messagesAndCodes.autoAddMessage(MAX_OWNERSHIP_STAKE_ERROR);
    }

    function changeMaximumPercentOwnership (uint256 _maxPercentOwnershipTimesOneThousand)
        public
        onlyOwner
    {
        require(_maxPercentOwnershipTimesOneThousand <= 1000, PERCENT_OUT_OF_BOUNDS_ERROR);
        maxPercentOwnershipTimesOneThousand = _maxPercentOwnershipTimesOneThousand;
    }

    function calcPercentTimesOneThousand(uint256 part, uint256 whole)
        internal
        pure
        returns (uint256)
    {
        uint256 numerator = part.mul(10000);
        require(numerator > part, "Integer overflow");
        uint256 quotient = numerator.div(whole).add(5).div(10);
        return quotient;
    }

    function detectTransferRestriction (address from, address to, uint256 value)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;
        uint256 expectedRecipientBalance = this.balanceOf(to).add(value);
        uint256 expectedPercentOwnershipTimesOneThousand = calcPercentTimesOneThousand(expectedRecipientBalance, this.totalSupply());
        bool exceedsMaxPercentOwnership = expectedPercentOwnershipTimesOneThousand > maxPercentOwnershipTimesOneThousand;
        if (exceedsMaxPercentOwnership) {
            restrictionCode = MAX_OWNERSHIP_STAKE_CODE;
        }
    }
}