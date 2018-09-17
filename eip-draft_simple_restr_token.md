---
eip: 1404
title: Simple Restricted Token Standard
authors: Ron Gierlach, James Poole, Mason Borda, Lawson Baker
status: Draft
discussions-to: https://github.com/simple-restricted-token/simple-restricted-token/issues
type: Standards
category (*only required for Standard Track): ERC
created: 2018-07-27
---

<!--You can leave these HTML comments in your merged EIP and delete the visible duplicate text guides, they will not appear and may be helpful to refer to if you edit it again. This is the suggested template for new EIPs. Note that an EIP number will be assigned by an editor. When opening a pull request to submit your EIP, please use an abbreviated title in the filename, `eip-draft_title_abbrev.md`. The title should be 44 characters or less.-->

# Simple Restricted Token Standard

## Simple Summary

<!--"If you can't explain it simply, you don't understand it well enough." Provide a simplified and layman-accessible explanation of the EIP.-->

A simple and interoperable standard for issuing tokens with transfer restrictions. The following draws on input from top issuers, law firms, relevant US regulatory bodies, and exchanges.  

## Abstract

<!--A short (~200 word) description of the technical issue being addressed.-->

Current ERC token standards have provided the community with a platform on which to develop a decentralized economy that is focused on building Ethereum applications for the real world. As these applications mature and face consumer adoption, they begin to interface with corporate governance requirements as well as regulations. They must not only be able to meet corporate and regulatory requirements but must also be able to integrate with technology platforms underpinning their associated businesses. What follows is a simple and extendable standard that seeks to ease the burden of integration for wallets, exchanges, and issuers.

## Motivation

<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->

Current regulatory and corporate requirements require that tokens with association to legal entities follow regulatory and corporate governance requirements. Current implementations that seek to solve this problem have yet to meet practical implementation requirements. Regulatory and corporate governance requirements manifest in the form of restrictions placed on a base ERC-20 token.

A few emergent examples:

- Enforcing Token Lock-Up Periods
- Enforcing Passed AML/KYC Checks
- Private Real-Estate Investment Trusts
- Delaware General Corporations Law Shares

Furthermore, standards adoption amongst token issuers has the potential to evolve into a dynamic and interoperable landscape of automated compliance.

The following design gives greater freedom / upgradability to token issuers and simultaneously decreases the burden of integration for developers and exchanges.

Additionally, we see fit to provide a pattern by which human-readable messages may be returned when token transfers are reverted. Transparency as to _why_ a token's transfer was reverted is of equal importance to the successful enforcement of the transfer restriction itself.

A widely adopted standard for detecting restrictions and messaging errors within token transfers will highly convenience the exchanges, wallets, and issuers of the future.

## Specification

<!--The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).-->

The ERC-20 token provides the following basic features:
```solidity
contract ERC20 {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
```
The ERC-1404 standard builds on ERC-20's interface, adding two functions:
```solidity
contract ERC1404 is ERC20 {
  function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
  function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
}
```

The logic of `detectTransferRestriction` and `messageForTransferRestriction` are left up to the issuer.

The only requirement is that `detectTransferRestriction` must be evaluated inside a token's `transfer` and `transferFrom` methods.

If, inside these transfer methods, `detectTransferRestriction` returns a value other than `0`, the transaction should be reverted.

## Rationale

<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

The standard proposes two functions and an event on top of the ERC-20 standard. Let's discuss the rationale for each.

1. `detectTransferRestriction` - This function is where an issuer enforces the restriction logic of their token transfers. Some examples of this might include, checking if the token recipient is whitelisted, checking if a sender's tokens are frozen in a lock-up period, etc. Because implementation is up to the issuer, this function serves solely to standardize _where_ execution of such logic should be initiated. Additionally, 3rd parties may publicly call this function to check the expected outcome of a transfer. Because this function returns a `uint8` code rather than a boolean or just reverting, it allows the function caller to know the reason why a transfer might fail and report this to relevant counterparties.
2. `messageForTransferRestriction` - This function is effectively an accessor for the "message", a human-readable explanation as to _why_ a transaction is restricted. By standardizing message look-ups, we empower user interface builders to effectively report errors to users.

## Backwards Compatibility

<!--All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.-->

By design ERC-1404 is fully backwards compatible with ERC-20.  
Some examples of how it may be integrated with common types of restricted tokens may be found [here](https://github.com/simple-restricted-token/simple-restricted-token-standard#readme).

## Test Cases & Implementation

<!--Test cases for an implementation are mandatory for EIPs that are affecting consensus changes. Other EIPs can choose to include links to test cases if applicable.-->

<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->

See the reference implementation and tests [here](https://github.com/simple-restricted-token/reference-implementation#readme).  
See some examples of common usage patterns for ERC-1404 [here](https://github.com/simple-restricted-token/simple-restricted-token-standard#readme).

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
