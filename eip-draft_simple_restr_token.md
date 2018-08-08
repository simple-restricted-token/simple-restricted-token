---
eip: <to be assigned>
title: Simple Restricted Token Standard
author: TokenSoft Inc (@tokensoft)
discussions-to: <URL>
status: Draft
type: Standards
category (*only required for Standard Track): ERC
created: <date created on, in ISO 8601 (yyyy-mm-dd) format>
---

<!--You can leave these HTML comments in your merged EIP and delete the visible duplicate text guides, they will not appear and may be helpful to refer to if you edit it again. This is the suggested template for new EIPs. Note that an EIP number will be assigned by an editor. When opening a pull request to submit your EIP, please use an abbreviated title in the filename, `eip-draft_title_abbrev.md`. The title should be 44 characters or less.-->

# Simple Restricted Token Standard, "SRS-20"

## Simple Summary

<!--"If you can't explain it simply, you don't understand it well enough." Provide a simplified and layman-accessible explanation of the EIP.-->

A simple and interoperable standard for issuing tokens with transfer restrictions.

## Abstract

<!--A short (~200 word) description of the technical issue being addressed.-->

Tokens with transfer restrictions lack a unifying interface for enforcing their restrictions and reporting subsequent errors.

An interoperable standard addressing this disunion will stimulate the next wave of integration for security token focused wallets, exchanges, and issuers.

## Motivation

<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->

There are many exciting use-cases for tokens with transfer restrictions.

A few emergent examples:

- Enforcing Token Lock-Up Periods
- Enforcing Passed AML/KYC Checks
- Private Real-Estate Investment Trusts
- Delaware General Corporations Law Shares

Furthermore, standards adoption amongst token issuers has the potential to evolve into a dynamic and interoperable landscape of automated compliance.

However, the current trend of ~~proposing~~ marketing token standards as solutions for individual use-cases poses a threat to future **interoperability** within the tokenized ecosystem.

Specifically this compromises the **usability** of security tokens and the exchanges that wish to support them.

It is our belief that a simplistic underlying standard, which may be easily extended for varying compliance needs, is a far more forward-thinking approach.

This design gives **greater freedom / upgradability** to token issuers and simultaneously decreases the burden of integration for developers and exchanges.

Additionally, we see fit to provide a pattern by which human-readable messages may be returned when token transfers are reverted.

**Transparency** as to _why_ a token's transfer was reverted is of equal importance to the successful enforcement of the transfer restriction itself.

A widely adopted pattern for handling rejections and messaging within token transfers will highly convenience the exchanges, wallets, and interface builders of the future.

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
The SRS-20 standard builds on ERC20's interface, adding two simple functions:
```solidity
interface SRS20 {
  /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
  /// @param from Sending address
  /// @param to Receiving address
  /// @param value Amount of tokens being transferred
  /// @return Code by which to reference message for rejection reasoning
  /// @dev Override with your custom transfer restriction logic
  function detectTransferRestriction (
    address from,
    address to,
    uint value
  ) external view returns (uint restrictionCode);

  /// @notice Returns a human-readable message for a given restriction code
  /// @param restrictionCode Identifier for looking up a message
  /// @return Text showing the restriction's reasoning
  /// @dev Override with your custom message and restrictionCode handling
  function messageForTransferRestriction (
    uint restrictionCode
  ) external view returns (string message);
}
```

The logic of `detectTransferRestriction()` and `messageForTransferRestriction()` are left up to the issuer, with just two requirements respectively:

1.  The token contract MUST perform a `detectTransferRestriction()` check inside `transfer` and `transferFrom` methods. If a value other than `0` is returned, revert the transaction.
2.  The token contract must implement `messageForTransferRestriction()` in such a way that a `restrictionCode` of `0` returns either a _success_ message or no message whatsoever.

**That's it. Seriously.**

## Rationale

<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

## Backwards Compatibility

<!--All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.-->

All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.

## Test Cases

<!--Test cases for an implementation are mandatory for EIPs that are affecting consensus changes. Other EIPs can choose to include links to test cases if applicable.-->

Test cases for an implementation are mandatory for EIPs that are affecting consensus changes. Other EIPs can choose to include links to test cases if applicable.

## Implementation

<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->

The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
