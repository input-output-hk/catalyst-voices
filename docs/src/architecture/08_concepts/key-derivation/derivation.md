---
Title: Catalyst HD Key Derivation for Off Chain ED25519 Signature Keys
Category: Catalyst
Status: Proposed
Authors:
    - Steven Johnson <steven.johnson@iohk.io>
Implementors: 
    - Catalyst Fund 14
Discussions: []
Created: 2024-11-29
License: CC-BY-4.0
---

## Abstract

Project Catalyst uses off chain keys, as a proxy for on-chain keys.
These keys need to be derived similar to the keys controlled by a wallet.
This document defines the Derivation path.

## Motivation: why is this CIP necessary?

A user will need a number of self generated and controlled signature keys.
They will need to be able to recover them from a known seed phrase, and also to roll them over.

This allows users to replace keys, and have them fully recoverable.
Which they may have to do if:

* Their keys are lost, and the account has to be recovered, or moved to a different device.
* Their keys are compromised (or suspected to be compromised), and they have to be replaced.

The keys are not controlled by a Blockchain wallet.
They are agnostic of any blockchain.
So, Project Catalyst must implement similar mechanisms as the wallets to safely derive keys for its use.

## Specification

For reference, see [CIP-1852].
This document is a modified implementation of this specification.

The basic structure of the Key Derivation path shall be:

```text
m / purpose' / type' / account' / role / index
```

In Cardano, both `purpose'` and `coin_type'` are notable years.
This specification uses [historical dates] related to democracy and voting.
This specification follows that convention but choose years more applicable to project Catalyst and its goals.
This specification also renames `coin_type'` to just `type'`, to be more generalized.

Changing the `purpose` and `type` values ensures that any keys derived for Project Catalyst will not
be derivable or collide with keys derived for Cardano.

* `purpose'` = `508` : Taken from year 508 BCE, the first known instance of democracy in human history.
    *"The Athenian Revolution,
    a revolt that overthrew the aristocratic oligarchy and established a participatory democracy in Athens"*.
* `type'` = `139` : Taken from the year 139 BCE, the first known instance of secret voting.
    *"A secret ballot is instituted for Roman citizens, who mark their vote on a tablet and place it in an urn."*
* `account'` = `0` : Reserved for future use cases.
    Always to be set to `0`.
* `role` = `0`-`n` : The role in the derivation maps 1:1 with the role number in the RBAC registration the key will be used for.
* `index` = `0`-`n` : The sequentially derived key in a sequence, starting at 0.
    Each new key for the same role just increments `index`.

## Reference Implementation

The first implementation will be Catalyst Voices.

*TODO: Generate a set of test vectors which conform to this specification.*

## Rationale: how does this CIP achieve its goals?

By leveraging known working Key Derivation techniques and simply modifying the path we inherit the properties of those methods.

## Path to Active

### Acceptance Criteria

Working Implementation before Fund 14.

### Implementation Plan

Fund 14 project catalyst will deploy this scheme for Key derivation.>

## Copyright

This document is licensed under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode).

[CIP-1852]: https://cips.cardano.org/cip/CIP-1852
[historical dates]: https://www.oxfordreference.com/display/10.1093/acref/9780191737152.timeline.0001
