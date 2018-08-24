# SRS-20: Simple Restricted Token Standard

SRS-20 is an easily extendable standard for issuing tokens with transfer restrictions.  
Read the [EIP draft](https://github.com/tokensoft/simple-restricted-token-standard/blob/master/eip-draft_simple_restr_token.md) to learn more.

## The Standard
The SRS-20 standard builds on ERC-20's interface, adding two functions:
```solidity
// The SRS-20 Interface

contract SRS20 is ERC20 {
  // returns a restriction code, where 0 is reserved for success
  function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);

  // returns a messsage string -- a human-readable message for the passed restriction code 
  function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
}
```

## Examples

### Common Restricted Tokens

Several common transfer restriction patterns implemented on SRS-20:

1.  [Account Ownership Percentage](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/cap-tables)
2.  Account Holding Periods - Coming Soon
3.  [Number of Accounts](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/shareholder-rules)
4.  [Whitelisted Accounts](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/whitelists)

### Other Standards

We have included example implementations of the following high-profile standards proposals on top of SRS-20:

1.  [Polymath's ST-20 Token](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/other-standards)
2.  [Harbor's R-Token](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/other-standards/R-Token)
3.  Delaware General Corporations Law (DCGL) ERC-884 Token - Coming Soon
