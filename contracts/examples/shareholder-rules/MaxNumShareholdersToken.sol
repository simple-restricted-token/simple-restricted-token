pragma solidity ^0.4.24;
import "../../token/SRS20/MessagedSRS20.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/// @title SRS-20 that limits the number of accounts to hold a token balance
/// @author TokenSoft Inc
contract MaxNumShareholdersToken is Ownable, MessagedSRS20 {
    uint256 public numShareholders = 0;
    uint256 public maxNumShareholders;
    uint8 public MAX_NUM_SHAREHOLDERS_CODE;
    string public constant MAX_NUM_SHAREHOLDERS_ERROR = "ILLEGAL_TRANSFER_MAXIMUM_NUMBER_OF_SHAREHOLDERS_REACHED";
    string public constant NEW_MAX_NUM_SHAREHOLDERS_ERROR = "New max number of shareholder accounts must be greater than the current amount";
    mapping(address => bool) public isShareholder;

    event ShareholderAdded(address indexed shareholder);
    event ShareholderReplaced(address indexed newShareholder, address indexed prevShareholder);
    event ChangedMaxNumShareholders(uint256 newMaxNumShareholders, uint256 prevMaxNumShareholders);

    constructor (uint256 _maxNumShareholders) public {
        maxNumShareholders = _maxNumShareholders;
        MAX_NUM_SHAREHOLDERS_CODE = messagesAndCodes.autoAddMessage(MAX_NUM_SHAREHOLDERS_ERROR);
    }

    function changeMaxNumShareholders (uint256 _maxNumShareholders)
        public
        onlyOwner
    {
        require(_maxNumShareholders >= numShareholders, NEW_MAX_NUM_SHAREHOLDERS_ERROR);
        emit ChangedMaxNumShareholders(_maxNumShareholders, maxNumShareholders);
        maxNumShareholders = _maxNumShareholders;
    }

    function detectTransferRestriction (address from, address to, uint256 value)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;

        bool exceedsMaxShareholders = calcNextNumShareholders(from, to, value) > maxNumShareholders;
        if (exceedsMaxShareholders) {
            restrictionCode = MAX_NUM_SHAREHOLDERS_CODE;
        }
    }

    function calcNextNumShareholders (address from, address to, uint256 value)
        internal
        view
        returns (uint256)
    {
        bool shareholderNotRecorded = !isShareholder[to];
        bool shareholderReplaced = (this.balanceOf(from) - value) == 0;
        bool senderNotRecorded = !isShareholder[from] && !shareholderReplaced;
        uint256 nextNumShareholders = numShareholders;

        if (shareholderNotRecorded) {
            nextNumShareholders++;
        }
        if (senderNotRecorded) {
            nextNumShareholders++;
        } else if (shareholderReplaced) {
            nextNumShareholders--;
        }

        return nextNumShareholders;
    }

    function recordShareholders (address from, address to, uint256 value)
        internal
    {
        bool shareholderNotRecorded = !isShareholder[to];
        bool shareholderReplaced = (this.balanceOf(from) - value) == 0;
        bool senderNotRecorded = !isShareholder[from] && !shareholderReplaced;

        if (shareholderNotRecorded) {
            numShareholders++;
            isShareholder[to] = true;
            emit ShareholderAdded(to);
        }
        if (senderNotRecorded) {
            numShareholders++;
            isShareholder[from] = true;
            emit ShareholderAdded(from);
        } else if (shareholderReplaced) {
            numShareholders--;
            isShareholder[from] = false;
            emit ShareholderReplaced(to, from);
        }
    }

    function transfer (address to, uint256 value)
        public
        returns (bool)
    {
        recordShareholders(msg.sender, to, value);
        return super.transfer(to, value);
    }

    function transferFrom (address from, address to, uint256 value)
        public
        returns (bool)
    {
        recordShareholders(from, to, value);
        return super.transferFrom(from, to, value);
    }
}