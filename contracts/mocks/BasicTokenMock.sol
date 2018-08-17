pragma solidity ^0.4.24;
import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";

/// @title Mock token contract using Open Zepplein's BasicToken
/// @dev Adapted from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/mocks/BasicTokenMock.sol
contract BasicTokenMock is BasicToken {
    constructor (address initialAccount, uint256 initialBalance) public {
        balances[initialAccount] = initialBalance;
        totalSupply_ = initialBalance;
    }
}
