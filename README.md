# SRS-20: Simple Restricted Token Standard

SRS-20 is an easily extendable standard for issuing tokens with transfer restrictions.  
Read the [EIP draft](https://github.com/tokensoft/simple-restricted-token-standard/blob/master/eip-draft_simple_restr_token.md) to learn more.

## The Standard
The SRS-20 standard builds on ERC-20's interface, adding two functions:
```solidity
contract SRS20 is ERC20 {
  function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
  function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
}
```

## Examples

### Common Restricted Tokens

Several common transfer restriction patterns implemented on SRS-20:

1.  [Cap Tables](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/cap-tables)
2.  Lock-Up Periods - Coming Soon
3.  [Maximum Shareholder Accounts](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/shareholder-rules)
4.  [Whitelisted Investor Addresses](https://github.com/tokensoft/simple-restricted-token-standard/tree/master/contracts/examples/whitelists)

<!-- ### Prominent Examples

We have included example implementations of the following high-profile standards proposals on top of SRS-20:

1.  [Harbor's R-Token](#)
2.  [Delaware General Corporations Law (DCGL) ERC-884 Token](#) -->
