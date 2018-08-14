pragma solidity ^0.4.14;
import "../../token/SRS20/MessagedSRS20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract MaximumShareholdersToken is Ownable, MessagedSRS20 {
    using SafeMath for uint256;
    uint8 public MAX_SHAREHOLDERS_CODE = 1;
    uint256 public numShareholders = 0;
    uint256 public maximumShareholders;

    mapping(address => bool) public isShareholder;

    constructor (uint256 _maximumShareholders, uint8 maxShareholdersCode) public {
        maximumShareholders = _maximumShareholders;
        if (maxShareholdersCode > 0) {
            MAX_SHAREHOLDERS_CODE = maxShareholdersCode;
        }
        messagesAndCodes.addMessage(
          MAX_SHAREHOLDERS_CODE,
          "ILLEGAL_TRANSFER_MAXIMUM_SHAREHOLDERS_REACHED"
        );
    }

    function changeMaximumShareholders (uint256 newMaximumShareholders)
        public
        onlyOwner
    {
        require(newMaximumShareholders >= numShareholders, "New maximum shareholders must be greater than the current number of shareholders");
        maximumShareholders = newMaximumShareholders;
    }

    function detectTransferRestriction (address from, address to, uint256 value)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;
        bool exceedsMaxShareholders = numShareholders < maximumShareholders;
        if (exceedsMaxShareholders) {
            restrictionCode = MAX_SHAREHOLDERS_CODE;
        }
    }

    function addOrRemoveShareholder (address from, address to, uint256 value)
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
        addOrRemoveShareholder(msg.sender, to, value);
        success = super.transfer(to, value);
    }

    function transferFrom (address from, address to, uint256 value)
        public
        returns (bool success)
    {
        addOrRemoveShareholder(from, to, value);
        success = super.transferFrom(from, to, value);
    }
}