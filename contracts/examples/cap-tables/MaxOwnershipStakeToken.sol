pragma solidity ^0.4.24;
import "../../token/SRS20/MessagedSRS20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/// @title SRS-20 that limits the ownership stake all accounts may hold
/// @author TokenSoft Inc
contract MaxOwnershipStakeToken is MessagedSRS20, Ownable {
    using SafeMath for uint256;
    uint8 public MAX_OWNERSHIP_STAKE_CODE = 1;
    uint256 public maximumPercentOwnershipTimesOneThousand;

    constructor (uint256 _maximumPercentOwnershipTimesOneThousand, uint8 maxOwnershipStakeCode) public {
        require(
            _maximumPercentOwnershipTimesOneThousand <= 1000,
            "Maximum percent ownership times 1000 must be less than or equal to 1000"
        );
        maximumPercentOwnershipTimesOneThousand = _maximumPercentOwnershipTimesOneThousand;
        if (maxOwnershipStakeCode > 0) {
            MAX_OWNERSHIP_STAKE_CODE = maxOwnershipStakeCode;
        }
        messagesAndCodes.addMessage(
            MAX_OWNERSHIP_STAKE_CODE,
            "ILLEGAL_TRANSFER_MAXIMUM_OWNERSHIP_STAKE_REACHED_FOR_RECIPIENT"
        );
    }

    function changeMaximumPercentOwnership (uint256 _maximumPercentOwnershipTimesOneThousand)
        public
        onlyOwner
    {
        require(
            _maximumPercentOwnershipTimesOneThousand <= 1000,
            "Maximum percent ownership times 1000 must be less than or equal to 1000"
        );
        maximumPercentOwnershipTimesOneThousand = _maximumPercentOwnershipTimesOneThousand;
    }

    function getPercentTimesOneThousand(uint256 part, uint256 whole)
        public
        pure
        returns (uint256)
    {
        uint256 numerator = part.mul(1000);
        require(numerator > part, "Overflow");
        uint256 temp = numerator.div(whole.add(5)); // proper rounding up
        return temp.div(10);
    }

    function detectTransferRestriction (address from, address to, uint256 value)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;
        uint256 expectedRecipientBalance = this.balanceOf(to).add(value);
        uint256 expectedPercentOwnershipTimesOneThousand = getPercentTimesOneThousand(expectedRecipientBalance, this.totalSupply());
        bool exceedsMaxPercentOwnership = expectedPercentOwnershipTimesOneThousand > maximumPercentOwnershipTimesOneThousand;
        if (exceedsMaxPercentOwnership) {
            restrictionCode = MAX_OWNERSHIP_STAKE_CODE;
        }
    }
}