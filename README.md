# Simple Restricted Token Standard

An easily extendable standard for issuing tokens with transfer restrictions.  

Extension of the standard lends to writing small, reusable contracts that are responsible for enforcing a single transfer restriction pattern.

Tokens leveraging the standard are best implemented by composing said contracts, as demonstrated in the [examples](#examples) section.  

Read the [EIP draft](https://github.com/simple-restricted-token/simple-restricted-token-standard/blob/master/eip-draft_simple_restr_token.md) to learn more.

## The Standard
The standard builds on ERC-20's interface, adding two functions:
```solidity
// The Simple Restricted Token Standard Interface

contract SRS20 is ERC20 {
  // returns a restriction code, where 0 is reserved for success
  function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);

  // returns a messsage string -- a human-readable message for the passed restriction code 
  function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
}
```

## Examples

### Common Restricted Tokens

Below are several common transfer restriction patterns implemented on SRS-20.  
These contracts are fully composable with each other; inherit from one or many of them to build out a bespoke restricted token contract.

1.  [Account Ownership Percentage](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/ownership-percentage)
2.  Account Holding Periods - Coming Soon
3.  [Number of Accounts](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/number-of-accounts)
4.  [Account Whitelists](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/whitelists)
5.  [Token Divisibility](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/divisibility)

### Other Standards

We have included example implementations of the following high-profile standards proposals on top of SRS-20:

1.  [Polymath's ST-20 Token](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/other-standards/ST20)
2.  [Harbor's R-Token](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/other-standards/R-Token)
3.  Delaware General Corporations Law (DGCL) ERC-884 Token - Coming Soon
