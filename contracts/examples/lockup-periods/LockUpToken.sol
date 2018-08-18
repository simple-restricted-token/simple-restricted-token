pragma solidity ^0.4.24;
import "../../token/SRS20/MessagedSRS20.sol";
import "zeppelin-solidity/contracts/access/Whitelist.sol";

contract LockUpToken is MessagedSRS20, Ownable {
    uint8 public TOKENS_LOCKED_CODE;
    uint256 public deployTime;
    uint256 public lockUpDuration;
    string public constant TOKEN_LOCKUP_ERROR = "ILLEGAL_TRANSFER_OF_TOKENS_IN_LOCKUP";

    event ChangedLockUpDuration(uint256 newLockUpDuration, uint256 oldLockUpDuration);

    constructor (uint256 lockUpDays) public {
        deployTime = block.timestamp;
        lockUpDuration = lockUpDays * 1 days;
        TOKEN_LOCKUP_ERROR = messagesAndCodes.autoAddMessage(NON_WHITELIST_ERROR);
    }

    function changeLockUpDuration (uint256 lockUpDays) public onlyOwner {
        emit ChangedLockUpDuration(lockUpDays * 1 days, lockUpDuration);
        lockUpDuration = lockUpDuration = lockUpDays * 1 days;
    }

    function detectTransferRestriction(address from, address to, uint256 value)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;

        uint256 releaseTime = deployTime + lockUpDuration;
        if (releaseTime > block.timestamp) {
            restrictionCode = TOKEN_LOCKUP_ERROR;
        }
    }
}
