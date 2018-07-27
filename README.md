# SRS-20: Simple Restricted Token Standard

SRS-20 is an easily extendable standard for issuing tokens with transfer restrictions. See [EIP-XXX](#) to learn more.

## Motivation

There are many exciting use-cases for tokens with transfer restrictions.

A few emergent examples:

- Enforcing Token Lock-Up Periods
- Enforcing Passed AML/KYC Checks
- Private Real-Estate Investment Trusts
- Delaware General Corporations Law Shares

Furthermore, standards adoption amongst token issuers has the potential to evolve into a dynamic and interoperable landscape of automated compliance.

However, we feel the current trend of ~~proposing~~ marketing token standards as solutions for individual use-cases poses a threat to future interoperability within the tokenized ecosystem.

Specifically this compromises the usuability of security tokens and the exchanges that wish to support them.

It is our belief that a simplistic underlying standard, which may be easily extended for varying compliance needs, is a far more forward-thinking approach.

This design gives greater freedom / upgradability to token issuers and simultaneously decreases the burden of integration for developers and exchanges.

Additionally, we see fit to provide a framework by which human-readable messages may be returned when token transfers are rejected.

Visibility into _why_ a token's transfer was rejected is of equal importance to the successful enforcement of the transfer restriction itself.

A widely adopted pattern for handling rejections and messaging within token transfers will highly convenience the exchanges, wallets, and interface builders of the future.

## The Standard

As a standard, SRS-20 is dead simple to implement.

It adds a public variable `restrictions` and _just one_ public function `detectTransferRestriction()` on top of the tried and true ERC-20 standard.

```solidity
/// @notice Stores human-readable restriction messages, mapped by uint codes
/// @dev 0 is always mapped to 'SUCCESS'
mapping (uint => string) public restrictions

/// @notice Detects if a transfer will be rejected and if so returns a corresponding code
/// @param {address} to - Receiving address
/// @param {address} from - Sending address
/// @param {uint} value - Amount tokens being transferred
/// @return {uint} retrictionCode - code by which to lookup the offending restriction
function detectTransferRestriction(address to, address from, uint value)
  public
  constant
  returns (uint restrictionCode)
{
  /* ... */
}
```

The logic of `detectTransferRestriction` is up to the issuer, with just two requirements:

1.  SRS-20 tokens must perform a `detectTransferRestriction` check inside `transfer` and `transferFrom` methods.
2.  The `detectTransferRestriction` function must return a `uint` restriction code, where `0` is reserved for `'SUCCESS'`.  
    All other returned codes must map to a human-readable message held in the public storage variable named `restrictions` (e.g. `mapping (uint => string) public restrictions`).  
    The `restrictions` variable must be directly accesible through the token contract.

Our [reference implementation](https://github.com/tokensoft/simple-restricted-token-standard/blob/master/contracts/SimpleRestrictedToken.sol) respects both these constraints and can easily be extended to handle more advanced use cases.

### Basic Usage

View on [Remix](https://remix.ethereum.org/#version=soljson-v0.4.24+commit.e67f0147.js&optimize=true&gist=264272677547fe32d1c2eb2fd8294315)

```solidity
contract MyRestrictedToken is SimpleRestrictedToken {
  constructor () public {
    // Map restriction codes to human-readable messages
    restrictions[1] = 'ILLEGAL_TRANSFER_TO_ZERO_ADDRESS';
    restrictions[2] = 'ILLEGAL_TRANSFER_TO_OWN_TOKEN_CONTRACT';

    // Set token details and initial balances
    /* ... */
  }

  // Detect restrictions and return appropriate codes
  function detectTransferRestriction (address to, address from, uint value)
    public
    constant
    returns (uint restrictionCode)
  {
    if (to == 0x0) {
      restrictionCode = 1; // illegal transfer to zero address
    } else if (to == address(this)) {
      restrictionCode = 2; // illegal transfer to own token contract
    } else {
      restrictionCode = 0; // successful transfer (default)
    }
  }
}
```

## Common Patterns

Several common transfer restriction patterns implemented under SRS-20:

1.  [Cap Tables](#)
2.  [Lock-Up Periods](#)
3.  [Maximum Shareholder Accounts](#)
4.  [Whitelisted Investor Addresses](#)

## Prominent Examples

SRS-20 is so easy to extend that we have included example implementations of the following high-profile standards on top of it:

1.  [Harbor's R-Token](#)
2.  [Polymath's ST-20 Token](#)
3.  [Delaware General Corporations Law (DCGL) ERC-884 Token](#)
