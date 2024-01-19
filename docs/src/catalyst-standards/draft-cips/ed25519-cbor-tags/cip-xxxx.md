---
CIP: /?
Title: CBOR Tag definition for CIP-0003 ED25519-BIP32 Keys
Category: MetaData
Status: Proposed
Authors:
    - Steven Johnson<steven.johnson@iohk.io>
Implementors: []
Discussions:
    - https://github.com/cardano-foundation/cips/pulls/?
Created: 2024-1-19
License: CC-BY-4.0
--- 

<!-- cspell: words secp -->

<!-- markdownlint-disable MD025-->
# [CBOR] Tag definition for [CIP-0003] [ED25519-BIP32] Keys

## Abstract

[CIP-0003] defines [ED25519-BIP32] Keys, Key derivation and a signature scheme.

These elements are commonly found in [CBOR] data structures within metadata on Cardano.
[CBOR] allows the definition of Tags to unambiguously define data structures encoded in [CBOR].
IANA maintains the registry of these Tags as the [IANA CBOR Tag Registry].
This CIP simply defines Tags to be registered with IANA and standardizes encoding of these data structures when the Tags are used.

While use of these tags would be recommended, they would not be mandatory.

## Motivation: why is this CIP necessary?

Tags are a useful addition to [CBOR] encoding which allows encoded data to be unambiguously identified.
Judicious use of tags in [CDDL] Specs and [CBOR] encoding can ease forward compatibility.
The Tag on an encoded field can be used to identify what is contained in a particular field.

For example, without this Tag definition, a metadata CIP which uses [ED25519-BIP32] public keys:

1. Is likely to just encode public keys as a byte string of 32 bytes; and
2. Needs to redundantly define how the keys are encoded in the byte string.
3. Different metadata may encode these keys differently which can lead to confusion and potential error.

However, [BIP32] defines secp256k1 keys and derivation, which are also 32 bytes long.  
There is no standard compliant way for a metadata CIP currently to clearly define which particular key is being encoded.
While bespoke schemes could be utilized, it is generally better to utilize pre-existing industry standards.
Bespoke schemes are also likely to vary from Metadata CIP to metadata CIP causing a lack of uniformity and greater chance of error.
Using the Tags system built into [CBOR] allows for uniformity of specification and encoding.
Not using Tags makes Metadata CIPs either more complex or limits their flexibility and constrains forward compatibility.

Bitcoin defines CBOR Tags at: [BCR-2020-006]

## Specification

| Type | [CBOR] Tag | IANA Registered |
| -- | -- | -- |
| [ED25519-BIP32 Private Key](#ed25519-bip32-private-key) | 32771 | :heavy_multiplication_x: |
| [ED25519-BIP32 Extended Private Key](#ed25519-bip32-extended-private-key) | 32772 | :heavy_multiplication_x: |
| [ED25519-BIP32 Public Key](#ed25519-bip32-public-key) | 32773 | :heavy_multiplication_x: |
| [ED25519-BIP32 Derivation Path](#ed25519-bip32-derivation-path) | 32774 | :heavy_multiplication_x: |
| [ED25519-BIP32 Private Key](#ed25519-bip32-signature) | 32775 | :heavy_multiplication_x: |

### ED25519-BIP32 Private Key

This key is defined in [ED25519-BIP32].

This is encoded as a byte string of size 32 bytes.

#### CDDL

```cddl
ed25519_private_key = #6.32771(bstr .size 32)
```

Data for the key inside the byte string is encoded in [network byte order].

### ED25519-BIP32 Extended Private Key

This key is defined in [ED25519-BIP32].

This is encoded as a byte string of size 64 bytes.

#### CDDL

```cddl
ed25519_extended_private_key = #6.32772(bstr .size 64)
```

Data for the key inside the byte string is encoded in [network byte order].

### ED25519-BIP32 Public Key

This key is defined in [ED25519-BIP32].

This is encoded as a byte string of size 32 bytes.

#### CDDL

```cddl
ed25519_public_key = #6.32773(bstr .size 32)
```

Data for the key inside the byte string is encoded in [network byte order].

### ED25519-BIP32 Derivation Path

[ED25519-BIP32] defines that the derivation path is composed of 32 bit integers.
Where the most significant bit defines if the derivation is hardened or not.

This is encoded as a CBOR Array, where each element is the component of the path.
There can be as many elements to the path as required.
Each element must be no larger than a 32 bit integer.

For example the path `m / 1852' / 1815' / 0' / 23 / 45` would be encoded as:

```cbor
[0x8000073c, 0x80000717, 0x80000000, 0x17, 0x2d]
```

#### CDDL

```cddl
ed25519_derivation_path = #6.32774([* path_element])
path_element = uint .le 0xffffffff
```

### ED25519-BIP32 Signature

[ED25519-BIP32] defines how signatures can be generated from private keys.
These signatures are defined to be 64 bytes long.

Signatures are encoded as a byte string of size 64 bytes.

#### CDDL

```cddl
ed25519_bip32_signature = #6.32775(bstr .size 64)
```

Data for the signature inside the byte string is encoded in [network byte order].

## Rationale: how does this CIP achieve its goals?

By defining concrete CBOR tags,  it is possible for metadata to unambiguously mark the kind of data encoded.
This is conformant with the intent of Tags in [CBOR], and aligns with prior use in [BCR-2020-006].
An official published spec is required to register these Tags with IANA and so this document also serves that purpose.

## Path to Active

### Acceptance Criteria

* At least 1 Metadata CIP uses at least 1 of the tags defined in this CIP.
* IANA register the Tags as defined.

### Implementation Plan

* Some of these Tags will be used by Project Catalyst in their new metadata CIPs.
* Project Catalyst will also make the application to IANA to register the Tags when appropriate.

## Copyright

This CIP is licensed under [CC-BY-4.0]

Code samples and reference material are licensed under [Apache 2.0]

[CC-BY-4.0]: https://creativecommons.org/licenses/by/4.0/legalcode
[Apache 2.0]: https://www.apache.org/licenses/LICENSE-2.0.html
[CBOR]: https://www.rfc-editor.org/rfc/rfc8949.html
[CDDL]: https://www.rfc-editor.org/rfc/rfc8610
[CIP-0003]: https://cips.cardano.org/cip/CIP-0003
[BIP32]: https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki
[BCR-2020-006]: https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-006-urtypes.md
[IANA CBOR Tag Registry]: https://www.iana.org/assignments/cbor-tags/cbor-tags.xhtml
[network byte order]: https://datatracker.ietf.org/doc/html/rfc1700
[ED25519-BIP32]: https://github.com/input-output-hk/adrestia/raw/bdf00e4e7791d610d273d227be877bc6dd0dbcfb/user-guide/static/Ed25519_BIP.pdf
