pragma solidity ^0.4.24;
import "../../token/SRS20/MessagedSRS20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract MaxNumShareholdersToken is Ownable, MessagedSRS20 {
    using SafeMath for uint256;
    uint8 public MAX_NUM_SHAREHOLDERS_CODE = 1;
    uint256 public numShareholders = 0;
    uint256 public maxNumShareholders;

    mapping(address => bool) public isShareholder;

    constructor (uint256 _maxNumShareholders, uint8 maxNumShareholdersCode) public {
        maxNumShareholders = _maxNumShareholders;
        if (maxNumShareholdersCode > 0) {
            MAX_NUM_SHAREHOLDERS_CODE = maxNumShareholdersCode;
        }
        messagesAndCodes.addMessage(
          MAX_NUM_SHAREHOLDERS_CODE,
          "ILLEGAL_TRANSFER_MAXIMUM_NUMBER_OF_SHAREHOLDERS_REACHED"
        );
    }

    function changeMaxNumShareholders (uint256 newmaxNumShareholders)
        public
        onlyOwner
    {
        require(newmaxNumShareholders >= numShareholders, "New maximum number of shareholders must be greater than the current number");
        maxNumShareholders = newmaxNumShareholders;
    }

    function detectTransferRestriction (address from, address to, uint256 value)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;
        bool exceedsMaxShareholders = numShareholders < maxNumShareholders;
        if (exceedsMaxShareholders) {
            restrictionCode = MAX_NUM_SHAREHOLDERS_CODE;
        }
    }

    function recordShareholder (address from, address to, uint256 value)
        internal
    {
        bool addingShareholder = !isShareholder[to];
        bool removingShareholder = this.balanceOf(from).sub(value) == 0;
        if (addingShareholder) {
            numShareholders = numShareholders.add(1);
            isShareholder[to] = true;
        }
        if (removingShareholder) {
            numShareholders = numShareholders.sub(1);
            isShareholder[from] = false;
        }
    }

    function transfer (address to, uint256 value)
        public
        returns (bool success)
    {
        recordShareholder(msg.sender, to, value);
        success = super.transfer(to, value);
    }

    function transferFrom (address from, address to, uint256 value)
        public
        returns (bool success)
    {
        recordShareholder(from, to, value);
        success = super.transferFrom(from, to, value);
    }
}