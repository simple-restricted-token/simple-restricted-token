pragma solidity ^0.4.24;
import "./MaxOwnershipStakeToken.sol";

/// @title SRS-20 that limits the ownership stake individual accounts may hold
contract IndividualOwnershipStakeToken is MaxOwnershipStakeToken {
    uint8 public INDIVIDUAL_MAX_OWNERSHIP_STAKE_CODE;
    mapping(address => bool) public individualAssignedMaxPercentOwnership;
    mapping(address => uint256) public individualMaxPercentOwnershipByAddress;
    string public constant INDIVIDUAL_MAX_OWNERSHIP_STAKE_ERROR = "ILLEGAL_TRANSFER_MAXIMUM_INDIVIDUAL_OWNERSHIP_STAKE_REACHED_FOR_RECIPIENT";

    event ChangedIndividualMaxOwnershipStake(
      address indexed individual,
      uint256 newIndividualMaxPercentOwnershipTimesOneThousand,
      uint256 oldIndividualMaxPercentOwnershipTimesOneThousand
    );

    constructor (uint256 globalMaxPercentOwnershipTimesOneThousand)
        MaxOwnershipStakeToken(globalMaxPercentOwnershipTimesOneThousand)
        public
    {
        INDIVIDUAL_MAX_OWNERSHIP_STAKE_CODE = messagesAndCodes.autoAddMessage(INDIVIDUAL_MAX_OWNERSHIP_STAKE_ERROR);
    }

    function resetIndividualPercentOwnership (address individual)
        public
        onlyOwner
    {
        emit ChangedIndividualMaxOwnershipStake(
            individual,
            maxPercentOwnershipTimesOneThousand,
            individualMaxPercentOwnershipByAddress[individual]
        );
        individualAssignedMaxPercentOwnership[individual] = false;
        individualMaxPercentOwnershipByAddress[individual] = 0;
    }

    function changeIndividualPercentOwnership (
        address individual,
        uint256 individualPercentOwnershipTimesOneThousand
    )
        public
        onlyOwner
    {
        require(individualPercentOwnershipTimesOneThousand <= 1000, PERCENT_OUT_OF_BOUNDS_ERROR);
        emit ChangedIndividualMaxOwnershipStake(
            individual,
            individualPercentOwnershipTimesOneThousand,
            individualMaxPercentOwnershipByAddress[individual]
        );
        individualAssignedMaxPercentOwnership[individual] = true;
        individualMaxPercentOwnershipByAddress[individual] = individualPercentOwnershipTimesOneThousand;
    }

    function detectTransferRestriction (address from, address to, uint256 value)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;
        // check if individual has been assigned a maximum
        if (individualAssignedMaxPercentOwnership[to]) {
            uint256 expectedRecipientBalance = this.balanceOf(to).add(value);
            uint256 expectedPercentOwnershipTimesOneThousand = calcPercentTimesOneThousand(expectedRecipientBalance, this.totalSupply());
            uint256 individualMaxPercentOwnership = individualMaxPercentOwnershipByAddress[to];
            bool exceedsMaxPercentOwnership = expectedPercentOwnershipTimesOneThousand > individualMaxPercentOwnership;
            if (exceedsMaxPercentOwnership) {
                restrictionCode = INDIVIDUAL_MAX_OWNERSHIP_STAKE_CODE;
            }
        // else default to the global maximum
        } else {
            restrictionCode = super.detectTransferRestriction(from, to, value);
        }
    }
}