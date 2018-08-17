pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/cap-tables/MaxOwnershipStakeToken.sol";

contract MaxOwnershipStakeTokenMock is BasicTokenMock, MaxOwnershipStakeToken {
    constructor (address initialAccount, uint256 initialBalance, uint256 _maximumPercentOwnershipTimesOneThousand)
        BasicTokenMock(initialAccount, initialBalance)
        MaxOwnershipStakeToken(_maximumPercentOwnershipTimesOneThousand)
        public
    {

    }
}
