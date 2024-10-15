# Transaction

---

Title: Voting Transaction

Status: Proposed

Authors:
    - Alex Pozhylenkov <alex.pozhylenkov@iohk.io>

Created: 2024-09-04

---

## Abstract

This document describes a specification of the different versions "Catalyst" voting transaction structure.
From the old one (Jörmungandr) to the newest.

## Motivation

Project "Catalyst" requires a structure to keep people vote's data in the secure way, anonymous and verifiable way.

## Specification

### v1 (Jörmungandr)

<!-- markdownlint-disable max-one-sentence-per-line code-block-style -->
??? note "V1 vote transaction definition: `tx_v1.abnf`"

    ```abnf
    {{ include_file('src/architecture/08_concepts/voting_transaction/tx_v1.abnf', indent=4) }}
    ```
<!-- markdownlint-enable max-one-sentence-per-line code-block-style -->

#### Example

V1 transaction representation in hex:

<!-- markdownlint-disable code-block-style -->
```hex
0000037e000b36ad42885189a0ac3438cdb57bc8ac7f6542e05a59d1f2e4d1d38194c9d4ac7b000203f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6fb0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6fc8f58976fc0e951ba284a24f3fc190d914ae53aebcc523e7a4a330c8655b4908f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6fb0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846021c76d0a50054ef7205cb95c1fd3f928f224fab8a8d70feaf4f5db90630c3845a06df2f11c881e396318bd8f9e9f135c2477e923c3decfd6be5466d6166fb3c702edd0d1d0a201fb8c51a91d01328da257971ca78cc566d4b518cb2cd261f96644067a7359a745fe239db8e73059883aece4d506be71c1262b137e295ce5f8a0aac22c1d8d343e5c8b5be652573b85cba8f4dcb46cfa4aafd8d59974e2eb65f480cf85ab522e23203c4f2faa9f95ebc0cd75b04f04fef5d4001d349d1307bb5570af4a91d8af4a489297a3f5255c1e12948787271275c50386ab2ef3980d882228e5f3c82d386e6a4ccf7663df5f6bbd9cbbadd6b2fea2668a8bf5603be29546152902a35fc44aae80d9dcd85fad6cde5b47a6bdc6257c5937f8de877d5ca0356ee9f12a061e03b99ab9dfea56295485cb5ce38cd37f56c396949f58b0627f455d26e4c5ff0bc61ab0ff05ffa07880d0e5c540bc45b527e8e85bb1da469935e0d3ada75d7d41d785d67d1d0732d7d6cbb12b23bfc21dfb4bbe3d933eaa1e5190a85d6e028706ab18d262375dd22a7c1a0e7efa11851ea29b4c92739aaabfee40353453ece16bda2f4a2c2f86e6b37f6de92dc45dba2eb811413c4af2c89f5fc0859718d7cd9888cd8d813da2e93726484ea5ce5be8ecf1e1490b874bd897ccd0cbc33db0a1751f813683724b7f5cf750f2497953607d1e82fb5d1429cbfd7a40ccbdba04fb648203c91e0809e497e80e9fad7895b844ba6da6ac690c7ce49c10e00000000000000000100ff00000000000000036d2ac8ddbf6eaac95401f91baca7f068e3c237386d7c9a271f5187ed909155870200000000e6c8aa48925e37fdab75db13aca7c4f39068e12eeb3af8fd1f342005cae5ab9a1ef5344fab2374e9436a67f57041899693d333610dfe785d329988736797950d
```
<!-- markdownlint-enable code-block-style -->

<!-- markdownlint-disable line-length code-block-style -->
1. Transaction size (u32): `0000037e`
2. `00`
3. Jörmungandr specific tag (u8): `0b`
4. Vote plan id (32 byte hash): `36ad42885189a0ac3438cdb57bc8ac7f6542e05a59d1f2e4d1d38194c9d4ac7b`
5. Proposal index (u8): `00`
6. Payload type tag (u8): `02`
7. Encrypted vote:
`03|f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6f|b0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846|f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6f|c8f58976fc0e951ba284a24f3fc190d914ae53aebcc523e7a4a330c8655b4908|f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6f|b0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846`
    * size (u8): `03`
    * ciphertext (group element (32 byte), group element (32 byte)): `f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6f|b0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846|f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6f|c8f58976fc0e951ba284a24f3fc190d914ae53aebcc523e7a4a330c8655b4908|f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6f|b0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846`
8. Proof: `02|1c76d0a50054ef7205cb95c1fd3f928f224fab8a8d70feaf4f5db90630c3845a|06df2f11c881e396318bd8f9e9f135c2477e923c3decfd6be5466d6166fb3c70|2edd0d1d0a201fb8c51a91d01328da257971ca78cc566d4b518cb2cd261f9664|4067a7359a745fe239db8e73059883aece4d506be71c1262b137e295ce5f8a0a|ac22c1d8d343e5c8b5be652573b85cba8f4dcb46cfa4aafd8d59974e2eb65f48|0cf85ab522e23203c4f2faa9f95ebc0cd75b04f04fef5d4001d349d1307bb557|0af4a91d8af4a489297a3f5255c1e12948787271275c50386ab2ef3980d88222|8e5f3c82d386e6a4ccf7663df5f6bbd9cbbadd6b2fea2668a8bf5603be295461|52902a35fc44aae80d9dcd85fad6cde5b47a6bdc6257c5937f8de877d5ca0356|ee9f12a061e03b99ab9dfea56295485cb5ce38cd37f56c396949f58b0627f455|d26e4c5ff0bc61ab0ff05ffa07880d0e5c540bc45b527e8e85bb1da469935e0d|3ada75d7d41d785d67d1d0732d7d6cbb12b23bfc21dfb4bbe3d933eaa1e5190a|85d6e028706ab18d262375dd22a7c1a0e7efa11851ea29b4c92739aaabfee403|53453ece16bda2f4a2c2f86e6b37f6de92dc45dba2eb811413c4af2c89f5fc08|59718d7cd9888cd8d813da2e93726484ea5ce5be8ecf1e1490b874bd897ccd0c|bc33db0a1751f813683724b7f5cf750f2497953607d1e82fb5d1429cbfd7a40c|cbdba04fb648203c91e0809e497e80e9fad7895b844ba6da6ac690c7ce49c10e`
    * size (u8): `02`
    * announcements (group element (32 byte), group element (32 byte), group element (32 byte)): `1c76d0a50054ef7205cb95c1fd3f928f224fab8a8d70feaf4f5db90630c3845a|06df2f11c881e396318bd8f9e9f135c2477e923c3decfd6be5466d6166fb3c70|2edd0d1d0a201fb8c51a91d01328da257971ca78cc566d4b518cb2cd261f9664|4067a7359a745fe239db8e73059883aece4d506be71c1262b137e295ce5f8a0a|ac22c1d8d343e5c8b5be652573b85cba8f4dcb46cfa4aafd8d59974e2eb65f48|0cf85ab522e23203c4f2faa9f95ebc0cd75b04f04fef5d4001d349d1307bb557`
    * ciphertext (group element (32 byte), group element (32 byte)): `0af4a91d8af4a489297a3f5255c1e12948787271275c50386ab2ef3980d88222|8e5f3c82d386e6a4ccf7663df5f6bbd9cbbadd6b2fea2668a8bf5603be295461|52902a35fc44aae80d9dcd85fad6cde5b47a6bdc6257c5937f8de877d5ca0356|ee9f12a061e03b99ab9dfea56295485cb5ce38cd37f56c396949f58b0627f455`
    * response randomness (scalar (32 byte), scalar (32 byte), scalar (32 byte)): `d26e4c5ff0bc61ab0ff05ffa07880d0e5c540bc45b527e8e85bb1da469935e0d|3ada75d7d41d785d67d1d0732d7d6cbb12b23bfc21dfb4bbe3d933eaa1e5190a|85d6e028706ab18d262375dd22a7c1a0e7efa11851ea29b4c92739aaabfee403|53453ece16bda2f4a2c2f86e6b37f6de92dc45dba2eb811413c4af2c89f5fc08|59718d7cd9888cd8d813da2e93726484ea5ce5be8ecf1e1490b874bd897ccd0c|bc33db0a1751f813683724b7f5cf750f2497953607d1e82fb5d1429cbfd7a40c`
    * scalar (32 byte): `cbdba04fb648203c91e0809e497e80e9fad7895b844ba6da6ac690c7ce49c10e`
9. `IOW` stand for Inputs-Outputs-Witnesses: `00000000000000000100ff00000000000000036d2ac8ddbf6eaac95401f91baca7f068e3c237386d7c9a271f5187ed909155870200000000e6c8aa48925e37fdab75db13aca7c4f39068e12eeb3af8fd1f342005cae5ab9a1ef5344fab2374e9436a67f57041899693d333610dfe785d329988736797950d`
    * Jörmungandr specific block date (epoch (u32), slot (u32))
    (*could be anything, not processed anymore*): `00000000|00000000`
    * number of inputs and witnesses (u8) (**always** `1`): `01`
    * number of outputs (u8) (**always** `0`): `00`
    * Inputs
    1.
        * Jörmungandr specific tag: `ff`
        * Jörmungandr specific value (u64) (*could be anything, not processed anymore*): `0000000000000003`
        * input pointer (32 byte): `6d2ac8ddbf6eaac95401f91baca7f068e3c237386d7c9a271f5187ed90915587`
    * Witnesses
    1.
        * Jörmungandr specific tag (u8): `02`
        * Jörmungandr specific nonce (u32) (*could be anything, not processed anymore*): `00000000`
        * legacy signature (64 byte): `e6c8aa48925e37fdab75db13aca7c4f39068e12eeb3af8fd1f342005cae5ab9a1ef5344fab2374e9436a67f57041899693d333610dfe785d329988736797950d`
<!-- markdownlint-enable max-one-sentence-per-line code-block-style -->

#### Transaction vote generation

To generate a cryptographically secured `ENCRYPTED-VOTE` and `PROOF-VOTE` parts you can follow this [spec](./crypto.md#vote).
Important to note,
that as part of [*initial setup*](./crypto.md#initial-setup) of the voting procedure,
the following properties are used:

1. Each proposal, defined by the "Vote plan id" and "Proposal index", defines a number of possible options.
2. [ristretto255] as a backend cryptographic group.
3. [BLAKE2b-512] hash function.
4. A commitment key $ck$ defined as a [BLAKE2b-512] hash of the "Vote plan id" bytes.

#### Transaction signing (witness generation)

Signature generated from the [BLAKE2b-256] hashed  `VOTE-PAYLOAD` bytes except of the `WITNESS` part
(the last part from the bytes array):

1. `CAST-CERT`  bytes
2. `BLOCK-DATE` bytes
3. `%x01`
4. `%x00`
5. `INPUT` bytes

Based on the on the transaction example, data to sign:

<!-- markdownlint-disable code-block-style -->
```hex
36ad42885189a0ac3438cdb57bc8ac7f6542e05a59d1f2e4d1d38194c9d4ac7b000203f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6fb0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6fc8f58976fc0e951ba284a24f3fc190d914ae53aebcc523e7a4a330c8655b4908f6639bdbc9235103825a9f025eae5cff3bd9c9dcc0f5a4b286909744746c8b6fb0018773d3b4308344d2e90599cd03749658561787eab714b542a5ccaf078846021c76d0a50054ef7205cb95c1fd3f928f224fab8a8d70feaf4f5db90630c3845a06df2f11c881e396318bd8f9e9f135c2477e923c3decfd6be5466d6166fb3c702edd0d1d0a201fb8c51a91d01328da257971ca78cc566d4b518cb2cd261f96644067a7359a745fe239db8e73059883aece4d506be71c1262b137e295ce5f8a0aac22c1d8d343e5c8b5be652573b85cba8f4dcb46cfa4aafd8d59974e2eb65f480cf85ab522e23203c4f2faa9f95ebc0cd75b04f04fef5d4001d349d1307bb5570af4a91d8af4a489297a3f5255c1e12948787271275c50386ab2ef3980d882228e5f3c82d386e6a4ccf7663df5f6bbd9cbbadd6b2fea2668a8bf5603be29546152902a35fc44aae80d9dcd85fad6cde5b47a6bdc6257c5937f8de877d5ca0356ee9f12a061e03b99ab9dfea56295485cb5ce38cd37f56c396949f58b0627f455d26e4c5ff0bc61ab0ff05ffa07880d0e5c540bc45b527e8e85bb1da469935e0d3ada75d7d41d785d67d1d0732d7d6cbb12b23bfc21dfb4bbe3d933eaa1e5190a85d6e028706ab18d262375dd22a7c1a0e7efa11851ea29b4c92739aaabfee40353453ece16bda2f4a2c2f86e6b37f6de92dc45dba2eb811413c4af2c89f5fc0859718d7cd9888cd8d813da2e93726484ea5ce5be8ecf1e1490b874bd897ccd0cbc33db0a1751f813683724b7f5cf750f2497953607d1e82fb5d1429cbfd7a40ccbdba04fb648203c91e0809e497e80e9fad7895b844ba6da6ac690c7ce49c10e00000000000000000100ff00000000000000036d2ac8ddbf6eaac95401f91baca7f068e3c237386d7c9a271f5187ed90915587
```
<!-- markdownlint-enable code-block-style -->

[BLAKE2b-256] hash of the transaction data to sign equals to `f51473df863be3e0383ce5a8da79c7ff51b3d98dadbbefbf9f042e8601901269`

Expected witness (includes signature)

<!-- markdownlint-disable code-block-style -->
```hex
    0200000000e6c8aa48925e37fdab75db13aca7c4f39068e12eeb3af8fd1f342005cae5ab9a1ef5344fab2374e9436a67f57041899693d333610dfe785d329988736797950d
```
<!-- markdownlint-enable code-block-style -->

## Rationale

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->

[BLAKE2b-256]: https://www.blake2.net/blake2.pdf\
[BLAKE2b-512]: https://www.blake2.net/blake2.pdf\
[ristretto255]: https://ristretto.group
