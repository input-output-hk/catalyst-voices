# Immutable Ledger Structure

---

Title: Immutable Ledger Structure Design

Status: Proposed

Authors:
    - Alex Pozhylenkov <alex.pozhylenkov@iohk.io>

Created: 2024-08-19

---

## Abstract

This document describes a specification of the immutable ledger structure for various purposes of project "Catalyst".

## Motivation

Project "Catalyst" requires a solution for storing people votes and any other data,
in a transparent, verifiable, scalable and immutable way.

## Specification

### Ledger structure

![Ledger schema](images/ledger_schema.svg){ align=right }

Ledger will be represented as a collection of different, non-connected chains,
processed and run in parallel.
The only common thing for all these chains will be a "tree" identifier,
so these chains will serve and form an overall ledger state.

Obviously, given approach leads to data duplication,
as each chain, will not know anything about others.
And it also requires that the overall ledger state,
could be deterministically defined at any point of time,
considering potential transaction overlapping or duplication.

Each particular chain, will be as a common sequence of blocks,
which are cryptographically protected by hashing.

The described approach allows to easily scale and increase throughput of the network on demand at any time,
just by starting to process new chains.
<br clear="right"/>

### Temporary chains

![Temporary chain schema](images/temporary_chain.svg){ align=right }

It is a common thing for blockchains to have a starting block (genesis),
but it's unusual to have a final block for a chain.
After which one no any block could be produced.

And that's a main distinguish for this Immutable Ledger Structure design,
it has a final block.

So any chain will be bounded by some period of time.
Which is well suited where it comes to process some temporary event e.g. voting.
<br clear="right"/>

### Block structure

```CDDL
{{ include_file('src/architecture/08_concepts/immutable_ledger/cddl/block.cddl') }}
```

#### Block fields description

Header:

* `chain_id` - unique identifier of the chain.
* `height` - block's height.
* `timestamp` - block's timestamp.
* `prev_block_id` - previous block hash.
* `ledger_type` - unique identifier of the ledger type.
  In general, this is the way to strictly bound and specify `block_data` of the ledger for the specific `ledger_type`.
  But such rules will be a part of the specific ledger type definition,
  and not specified by this document.
* `purpose_id` - unique identifier of the purpose.
  As it was stated before,
  each Ledger instance will have a strict time boundaries,
  so each of them will run for different purposes.
  This is the way to distinguish them.
* `validator` - identifier or identifiers of the entity who was produced and processed a block.
* `metadata` - fully optional field, to add some arbitrary metadata to the block.

Block:

* `block_header` - block header described above,
* `block_data` - an array of some CBOR encoded data
* `validator_signature` - a signature or signatures of the validator's.

### Block validation rules

* `chain_id` **MUST** be the same as for the previous block (except for genesis).
* `height` **MUST** be incremented by `1` from the previous block height value (except for genesis and final block).
  *Genesis* block **MUST** have `0` value.
  *Final* block **MUST** hash be incremented by `1` from the previous block height and changed the sign to negative.
  E.g. previous block height is `9` and the *Final* block heigh is `-10`.
* *Final* block is the last one for the specific chain and any other block could not be refenced to the *Final* one.

* `timestamp` **MUST** be greater or equals than the `timestamp` of the previous block (except for genesis).
* `prev_block_id` **MUST** be a hash of the previous block bytes (except for genesis).

* `ledger_type` **MUST** be the same as for the previous block if present (except for genesis).
  **MANDATORY** field for *Genesis* block and *Final* blocks.
* `purpose_id` **MUST** be the same as for the previous block if present (except for genesis).
  **MANDATORY** field for *Genesis* block and *Final* blocks.
* `validator` **MUST** be the same as for the previous block if present (except for genesis).
  **MANDATORY** field for *Genesis* block and *Final* blocks.

* `prev_block_id` and `validator_signature` **MUST** use the same hash function, defined with the
  `hash_bytes`.

* `validator_signature` **MUST** be a signature of the hashed `block_header` bytes with the `block_data` bytes,
  signed by the validator's keys defined in the corresponding certificates referenced by the `validator`.
  The format and size of this field **MUST** be totally the same as `validator` field:
  if `validator` is only one id => `validator_signature` contains only 1 signature;
  if `validator` is array => `validator_signature` contains an array with the same length;
  order of signatures from the `validator_signature`'s array corresponds to the validators order of `validator`'s array.
  Signature algorithm is defined by the certificate.

* `prev_block_id` for the *Genesis* block **MUST** be a hash of the `genesis_to_prev_hash` bytes.

```CDDL
{{ include_file('src/architecture/08_concepts/immutable_ledger/cddl/genesis_to_prev_hash.cddl') }}
```

## Rationale

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->
