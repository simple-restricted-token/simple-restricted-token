# Simple Restricted Token Standard

An easily extendable standard for issuing tokens with transfer restrictions.  

Read [ERC-1404](https://github.com/ethereum/EIPs/issues/1404) to learn more.

### For Developers
Use of the standard lends to writing _small_, _reusable_ smart contracts that are responsible for enforcing a single transfer restriction pattern.

Tokens implementing the standard are best constructed by composing said restrictions through multiple contract inheritance.

### For Lawyers
You may have been seeking a way for your issuers to enforce investor limits, control flowback between US and non-US investors, or other similar restrictions.  

The standard provides an avenue by which a team of capable engineers may meet those requirements.

### For Issuers
Your counsel may have asked you questions similar to the following:

* "How can we limit the number of token holders to 2,000 persons or less?"
* "How can we prevent flowback from non-US token holders to US token holders?"
* "What if a sanctioned persons gets a hold of the token? Can you take it away?"

While this standard does not inherently enable compliance, it does provide the tools necessary to comply with requirements as put forth by counsel.

## The Standard
The standard builds on ERC-20's interface, adding two functions:
```solidity
// The Simple Restricted Token Standard Interface

contract ERC1404 is ERC20 {
  // returns a restriction code, where 0 is reserved for success
  function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);

  // returns a message string -- a human-readable message for the passed restriction code 
  function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
}
```

## Examples

### Common Restricted Tokens

Below are several common transfer restriction patterns implemented on ERC-1404.  

These contracts are fully composable with each other. Inherit from one or several to build out a bespoke restricted token contract.

1.  [Account Ownership Percentage](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/ownership-percentage)
2.  Account Holding Periods - WIP
3.  [Number of Accounts](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/number-of-accounts)
4.  [Account Whitelists](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/whitelists)
5.  [Token Divisibility](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/divisibility)

### Other Standards

We have included example implementations of the following high-profile standards proposals on top of ERC-1404:

1.  [Polymath's ST-20 Token](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/other-standards/ST20)
2.  [Harbor's R-Token](https://github.com/simple-restricted-token/simple-restricted-token-standard/tree/master/contracts/examples/other-standards/R-Token)
3.  Delaware General Corporations Law (DGCL) ERC-884 Token - WIP
