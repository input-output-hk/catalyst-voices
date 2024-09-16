# Immutable Ledger Design

---

Title: Immutable Ledger Design

Status: Proposed

Authors:
    - Alex Pozhylenkov <alex.pozhylenkov@iohk.io>

Created: 2024-08-19

---

## Abstract

This document describes a specification of the immutable ledger for various purposes of project "Catalyst".

## Motivation

Project "Catalyst" requires a solution for storing people votes and any other data,
in a transparent, verifiable, scalable and immutable way.

## Specification

### Ledger structure

![Ledger schema](images/ledger_schema.svg){ align=right }

Ledger will be represented as a collection of distinct, unconnected chains,
processed and run in parallel.
The only common thing for all these chains will be a "tree" identifier,
so these chains will serve and form an overall ledger state.

Obviously, given approach leads to data duplication,
as each chain, will not know anything about others.
And it also requires that the overall ledger state,
could be deterministically defined at any point of time,
considering potential transaction overlapping or duplication.

To achieve an immutability of data inside each chain
Each particular chain, will be a common sequence of blocks.
To achieve an immutability of data inside each chain,
cryptographic hashing is applied.
So each block from the chain reference to the hash of previous one.
It is a widely used technic to prevent a modification of some data from previous blocks,
without affecting structure of the current one.

The described approach allows to easily scale and increase throughput of the network on demand at any time,
just by starting to process new chains.
<!-- markdownlint-disable no-inline-html -->
<br clear="right"/>
<!-- markdownlint-enable no-inline-html -->

### Temporary chains

![Temporary chain schema](images/temporary_chain.svg){ align=right }

It's a common thing for blockchains to have a starting block (genesis),
but it's unusual to have a final block for a chain.
After which no any block could be produced.

And that's a main distinguish for this Immutable Ledger design,
it has a final block.

So any chain will be bounded by some period of time.
Which is well suited where it comes to process some temporary event e.g. voting.
<!-- markdownlint-disable no-inline-html -->
<br clear="right"/>
<!-- markdownlint-enable no-inline-html -->

### Block structure

<!-- markdownlint-disable max-one-sentence-per-line code-block-style -->
??? note "Block CDDL definition: `block.cddl`"

    ```CDDL
    {{ include_file('src/architecture/08_concepts/immutable_ledger/cddl/block.cddl', indent=4) }}
    ```
<!-- markdownlint-enable max-one-sentence-per-line code-block-style -->

Header:

* `chain_id` - unique identifier of the chain.
* `height` - block's height.
  Also is used to identify the block type: *genesis*, *regular*, *final*
  (in more details described in [validation section](#block-validation-rules)).
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
  E.g. previous block height is `9` and the *Final* block height is `-10`.
* *Final* block is the last one for the specific chain and any other block could not be referenced to the *Final* one.

* `timestamp` **MUST** be greater or equals than the `timestamp` of the previous block (except for genesis).
* `prev_block_id` **MUST** be a hash of the previous block bytes (except for genesis).

* `ledger_type` **MUST** be the same as for the previous block if present (except for genesis).
  **MANDATORY** field for *Genesis* and *Final* blocks.
* `purpose_id` **MUST** be the same as for the previous block if present (except for genesis).
  **MANDATORY** field for *Genesis* and *Final* blocks.
* `validator` **MUST** be the same as for the previous block if present (except for genesis).
  **MANDATORY** field for *Genesis* and *Final* blocks.
* `prev_block_id`'s CBOR tag value and `bstr` size **MUST** be the same as for the previous block (except for genesis).
  Means that the hash function type and hash size itself must be the same.
* `prev_block_id` and `validator_signature` **MUST** use the same hash function, defined with the
  `hash_bytes`.

* `prev_block_id` for the *Genesis* block **MUST** be a hash of the `genesis_to_prev_hash` bytes.

* `block_data` **MUST** be a [deterministically][CBOR-deterministically-encoded] encoded CBOR.

<!-- markdownlint-disable max-one-sentence-per-line code-block-style -->
??? note "Genesis to previous block hash CDDL definition: `genesis_to_prev_hash.cddl`"

    ```CDDL
    {{ include_file('src/architecture/08_concepts/immutable_ledger/cddl/genesis_to_prev_hash.cddl',indent=4) }}
    ```
<!-- markdownlint-enable max-one-sentence-per-line code-block-style -->

#### Signature rules

`validator_signature`
**MUST** be a signature of the hashed `block_header` bytes and the `block_data` bytes
(with the order the same as defined for `block`).
Signed by the validator's keys defined in the corresponding certificates referenced by the `validator`.
Signature algorithm is defined by the certificate.
The format and size of this field **MUST** be totally the same as `validator` field:

* if `validator` is only one id => `validator_signature` contains only 1 signature;
* if `validator` is array => `validator_signature` contains an array with the same length;
* order of signatures from the `validator_signature`'s array corresponds to the validators order of `validator`'s array.

## Rationale

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->

[CBOR-deterministically-encoded]: https://datatracker.ietf.org/doc/html/rfc8949#name-deterministically-encoded-c
