pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../examples/ownership-percentage/IndividualOwnershipStakeToken.sol";

contract IndividualOwnershipStakeTokenMock is BasicTokenMock, IndividualOwnershipStakeToken {
    constructor (address initialAccount, uint256 initialBalance, uint256 globalMaxPercentOwnershipTimesOneThousand)
        BasicTokenMock(initialAccount, initialBalance)
        IndividualOwnershipStakeToken(globalMaxPercentOwnershipTimesOneThousand)
        public
    {

    }
}
