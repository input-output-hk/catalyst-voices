# Voting Ledger Structure

---
Title: Voting Ledger Chain Structure
Status: Proposed
Authors:
    - Alex Pozhylenkov <alex.pozhylenkov@iohk.io>
Created: 2024-08-19
License: CC-BY-4.0
---

## Abstract

This document describes a specification of the voting ledger for the "Catalyst Voices" platform.

## Motivation

A new Catalyst voting platform "Catalyst Voices" requires a solution for storing people votes,
in a transparent, verifiable, scalable and immutable ledger.

## Specification

### Ledger structure

Voting ledger will be represented as a collection of different, non connected chains,
processed and run in parallel.
The only common thing for all these chains will be a "tree" identifier,
so these chains will serve and form an overall ledger state.

Obviously, given approach leads to the data duplication,
as each chain will not know anything about others.
And it also requires that the overall ledger state,
could be deterministically defined at any point of time,
concidering potential transaction overlapping or duplication.

Hopefully, the "nature" of voting transactions allow us to do that,
which will be discussed in the other section.

Each particular chain, will be as a common sequance of blocks,
which are cryptographically protected by hashing.

The described approach allows to easily scale and increase throughput of the network on demand at any time,
just by starting to process new chains.

![Ledger schema](images/ledger_schema.svg)

### Block structure

```CDDL
 {{ include_file('src/architecture/08_concepts/voting_ledger/cddl/block.cddl', indent=4) }}
```

### Block validation rules

* `tree_id` **MUST** be the same as for the previous block.
* `chain_id` **MUST** be the same as for the previous block.
* `validator_id` **MUST** be the same as for the previous block.
* `prev_block_id` **MUST** be a hash of the previous block header bytes.
* `timestamp` **MUST** be higher than the `timestamp` of the previous block.
* `validator_signature` **MUST** be a signature of the hashed block header bytes signed by the validator,
  referenced in the `validator_id`.
* `prev_block_id` and `validator_signature` **MUST** use the same hash function, defined with the `hash_bytes`

## Rationale
<!-- The rationale fleshes out the specification by describing what motivated the design and what led to particular design decisions. It should describe alternate designs considered and related work. The rationale should provide evidence of consensus within the community and discuss significant objections or concerns raised during the discussion.

It must also explain how the proposal affects the backward compatibility of existing solutions when applicable. If the proposal responds to a CPS, the 'Rationale' section should explain how it addresses the CPS, and answer any questions that the CPS poses for potential solutions.
-->

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->

## Copyright
<!-- The CIP must be explicitly licensed under acceptable copyright terms.  Uncomment the one you wish to use (delete the other one) and ensure it matches the License field in the header: -->

<!-- This CIP is licensed under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode). -->
<!-- This CIP is licensed under [Apache-2.0](http://www.apache.org/licenses/LICENSE-2.0). -->
