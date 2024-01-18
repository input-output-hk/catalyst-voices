---
CIP: /?
Title: Role based Access Control Registration
Category: MetaData
Status: Proposed
Authors:
    - Steven Johnson<steven.johnson@iohk.io>
Implementors: []
Discussions:
    - https://github.com/cardano-foundation/cips/pulls/?
Created: 2023-10-24
License: CC-BY-4.0 / Apache 2.0
---

<!-- markdownlint-disable MD025-->
# Role Based Access Control Registration

## Abstract
<!-- A short (\~200 word) description of the proposed solution and the technical issue being addressed. -->
dApps such as Project Catalyst need robust, secure and extensible means for users to register under various roles
and for the dApp to be able to validate actions against those roles.
While these Role based registrations are required for future functionality of Project Catalyst, they are also
intended to be generally useful to any dApp with User roles.

## Motivation: why is this CIP necessary?
<!-- A clear explanation that introduces the reason for a proposal, its use cases and stakeholders. 
If the CIP changes an established design then it must outline design issues that motivate a rework. 
For complex proposals, authors must write a Cardano Problem Statement (CPS) as defined in CIP-9999 
and link to it as the `Motivation`. -->

CIP-36 contains a limited form of role registration limited to voters and dreps.

However, Project Catalyst has a large (and growing) number of roles identified in the system, all of
which can benefit from on-chain registration.

A non-exhaustive list of the roles Project Catalyst needs to identify on-chain are:

1. Proposers.
2. Co-Proposers.
3. Proposal Reviewers.
4. Voters.
5. Representative voters.
6. Tally committee members.
7. Administrators.
8. Audit committee members.

Individual dApps may have their own unique list of roles they wish users to register for.
Roles are such that an individual user may hold multiple roles, one of the purposes of this
CIP is to allow the user  to unambiguously assert they are acting in the capacity of a selected role.

CIP-36 offers a "purpose" field, but offers no way to manage it, and offers no way to allow it to be used unambiguously.
The "purpose" field therefore is insufficient for the needs of identifying roles.

CIP-36 also does not allow the voting key to be validated.
This makes it impossible to determine if the registration voting key is usable, and owned by the registering user, or has
been duplicated from another registration on-chain or is just a random number.

It also offers no way to identify the difference between a voter registering for themselves, and a voter registering to be a dRep.

These are some of the key reasons, CIP-36 is insufficient for future Project Catalyst needs.

Registering for various roles and having role specific keys is generally useful for dApps, so while this CIP is
motivated to solve problems with Project Catalyst, it is also intended to be generally applicable to other dApps.

## Specification
<!-- The technical specification should describe the proposed improvement in sufficient technical detail. 
In particular, it should provide enough information that an implementation can be performed solely on the basis 
of the design in the CIP. 
This is necessary to facilitate multiple, interoperable implementations. 
This must include how the CIP should be versioned. 
If a proposal defines structure of on-chain data it must include a CDDL schema in it's specification.-->

Role registration is achieved by using two metadata records attached to the same transaction.

### Metadata Labels

| Metadata Label | Description |
| ---   | --- |
| `7222` | The RBAC Metadata Label |
| `7223` | The RBAC Metadata witness set Label |

Both pieces of metadata must be present in the same transaction for the registration to be valid.

`7222` AND `7223` define this Metadata as being Role Registration Metadata.
These Metadata key should not be used for another purpose.

Note: **7222 is RBAC when decoded using the telephone ITU E.161 standard**

### Metadata Encoding

* The metadata will be encoded with [CBOR].
* The [CBOR] metadata will be encoded strictly according to [CBOR - Core Deterministic Encoding Requirements].
* There **MUST NOT** be any duplicate keys in a map.
* UTF-8 strings **MUST** be valid UTF-8.
* Tags **MUST NOT** be used unless specified in the specification.
* Any Tags defined in the specification are **REQUIRED**, and they **MUST** be present in the encoded data.
* Fields which should be tagged, but which are not tagged will be considered invalid.

These validity checks apply only to the encoding and decoding of the metadata itself.  
There are other validity requirements based on the role registration data itself.
Each dApp may have further validity requirements beyond those stated herein.

### High level overview of Role Registration metadata

At a high level, Role registration will collect the following data:

1. A [role public key or non-empty list of role public keys](#subkey-1---role-specific-public-key-or-role-public-key-array);
2. A [stake address for the network that this transaction is submitted to]();
3. An *Optional* [Shelley payment address]().
4. A [nonce]() that identifies that most recent registration.
5. The [role]() being registered.
6. A [dApp ID]() which defines the dApp the registration belongs to.
6. An *Optional* [expiry timestamp]().
7. Optional dApp defined [extended registration metadata]().

The formal specification for the `7222` Metadata is [CIPxxxx Metadata CDDL][].

Informally, all Registrations follow the same generalized Format (Non-Normative):

```cbor
7222: {
  // Role Public Key or Role Public Key Array
  1: #6.??? h'a6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663' ; or
     [#6.??? h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C', 
      #6.??? h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97'] ; or
     [
      [#6.??? h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C', 50], 
      [#6.??? h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97', 50]
     ]
  // Stake Public Key
  2: #6.??? h'ad4b948699193634a39dd56f779a2951a24779ad52aa7916f6912b8ec4702cee',
  // Payment Address
  3: #6.???h'00588e8e1d18cba576a4d35758069fe94e53f638b6faf7c07b8abd2bc5c5cdee47b60edc7772855324c85033c638364214cbfc6627889f81c4',
  // nonce
  4: 5479467,
  // Role
  5: 0,
  // dApp ID (UUID or ULID)
  6: h'',
  // Expires - Optional
  7: 0,
  // dApp Defined Metadata - Optional
  100: <Any>
}
```

Keys between `8` and `99` are reserved for any future extensions to this specification.
They must not be defined by any dApp for private use.
These keys, if defined, will be defined by a CIP which extends this base specification.

Keys above `100` are reserved for dApp specific use, and may be defined either formally by a CIP or informally by any dApp.
General parsers of this data should accept, but not otherwise interpret keys `100`+ unless they specifically understand
the requirements of the identified dApp.

### Subkey 1 - Role Specific Public Key OR Role Public Key Array

Subkey 1 is either:

* A Single [Role Specific Public Key](#subkey-1---role-key---single-role-specific-public-key); OR
* A [Optionally Weighted List of Role Specific Public Keys](#grouped-role-registration-format).

#### SubKey 1 - Role Key - Single Role Specific Public Key

The Role Key is an [Ed25519-BIP32][CIP0003] public key.

This is represented as a CBOR Byte-string, 32 bytes long.
It is tagged with `#6.???` to unambiguously identify the key type.
This is to allow the specification to evolve in a forward compatible manor if new key types are introduced.

Any and All authoritative actions performed under the registered Role MUST be signed with an owned Role Key.
How the dApp signs the data and what format that data or signature takes is not defined in this CIP.

The Witness data informs if the Role key is being used by reference, and is not owned by the registration,
or is owned and controlled by the registration.
This distinction is important in cases where a Role is being delegated to another registration.
The definition of the `purpose` will declare if it is valid for a particular Role to delegate or not and is
outside the scope of this specification.

Role keys MUST be derived using the following specific key derivation path.
This is to allow Key recovery across compatible wallets.
An implementation will be non-conforming to this specification if it does not use the defined Key derivation path.

It is valid for multiple Stake addresses to register with the same Role key, but they MUST prove ownership of the key
otherwise it will be identified as a delegation.
The dApp defines the limits of this relationship, and that can differ on a role by role basis.

Role keys MUST, as far as practically possible, be unique to a dApp to ensure they are not improperly used across dApps.
The aim is for a Role key to unambiguously declare the intention of the user to act with their role.
See [Key Derivation](#key-derivation) for details on how the Role key MUST be derived from the master key of the wallet.

Other than the fact that a registration unambiguously associates one or more Stake addresses to a Role Specific Public Key,
this CIP does not define how that is validated for any particular dApp or Role.
A later section of this CIP will demonstrate possible validation scenarios that a dApp can adopt.

Example:

```cbor
h'a6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663'
```

##### Key Derivation

It is REQUIRED that path based key derivation be used to generate the Role Specific Public Key.
If a wallet is incapable of using path based key derivation as defined by this specification it is
not capable of conforming to the requirements of this specification.

Key derivation is used to avoid linking Role access keys directly with Cardano spending keys.
It also provides a mechanism to unambiguously identify the role being asserted when data is signed.

The Role Specific key derivation path must start with a specific segment:

Path based key derivation is limited to 31 bits, per path component.
The [dApp ID]() is 128 bits.  
It is required that the Role key be, as far as practically possible, unique amongst dApps.
This is to prevent a Role from one dApp being misused by another, either intentionally or inadvertently.

The [dApp ID]() will be reduced to 31 bits by using Blake2B with a 31 bit digest over the [dApp ID]().
While 31 bits is small, and could be subject to a collision attack, the intention here is not to prevent
deliberately contrived collisions but to disambiguate dApps under normal circumstances.
As the [dApp ID]() is not controllable, a malicious dApp could simply use the same dApp ID as another.
Therefore it is not possible to protect against a collision and the [dApp ID]() is not a security mechanism
in any event.

However key derivation is limited to 31 bits, accordingly, the [dApp ID][] will be hashed with Blake2B and a
31 bit digest will be produced.
The aim is to as far as practical cause dApps to have distinct Role keys under normal circumstances.

`m / 7222' / 1815' / account' / chain' / blake2b_31(dApp ID) / role`

* `7222'` : The registration metadata field key from this CIP.
* `1815'` : The year Ada Lovelace was born - Identifies this key as being for Cardano.
* `account'` : The voters account
* `chain'` : The chain on which the voter is registering.
* `blake2b_31(uuid)` : The [dApp ID]()
* `role` :  The role being registered for.

Note: It is specifically required that the Role Key NOT CHANGE for registrations made from the same wallet for the same dApp UUID/Purpose.
This is because its possible to make both single and array role registrations, and its critical the key be the same regardless of which is used.
The necessity of this will be expanded on when the witness is discussed below.

If the wallet does not use path based key derivation it is Essential that:

* Role Specific Public Keys do not change from registration to registration for the same [dApp UUID][dApp-UUID]/Purpose.
* Role Specific Public Keys are not the same for different Purposes for a UUID.
* It is acceptable, though undesirable, for different [dApp UUID's][dApp-UUID] to use the same Role Specific Public Keys.

#### SubKey 1 - Role Key - List of Role Keys

Catalyst has the need to associate role registrations as a list, and optionally to have those registrations weighted.
For example, this will be used to:

* Define Voter Delegation to representatives.
* Define Co-Proposers for Catalyst proposals.

It is generally useful to be able to associate multiple role public keys together.

How these role registration lists are used and validated by any dApp are outside the scope of this CIP.
The [individual role keys](#subkey-1---role-key---single-role-specific-public-key) within a Role Key list are defined
according to this specification above.

There are two possible General formats of a role registration list is:

* [Simple Role Key List](#simple-role-key-list)
* [Weighted Role Key List](#weighted-role-key-list)

A simple list is equivalent to a weighted role key list.
If a Weighted list is expected in a registration, and a simple list is found in a registration,
then it is interpreted as a weighted role key list where each entry is equally weighted.
This can be used to decrease the size of the registration metadata by eliding the weights when
they are all the same.

However, the converse is not true.
If a Role expects a simple role key list, and a weighted role key list is found in the registration then
the format is invalid.  
This is because it is not possible to determine the expected behavior of the unused weights.

* [\<Role Public Key\>](#subkey-1---role-key---single-role-specific-public-key) : is the role specific public key defined above.
  * This key can belong to the registering user themselves; or
  * Can belong to another user,  either from the same or a different role registration.
  * Must be for the same [dApp UUID][dApp-UUID].  (Cross dApp Registrations is not defined or supported by this CIP).
* <Weight> : is a 4-byte unsigned integer (CBOR major type 0, The weight may range from 0 to 2^32-1).
  * The dApp defines what the weight means.
  * Other than validating it is in-range no further validation is done at the base registration level.
  * For example:
    * Project Catalyst uses the weight to apportion Voting Power in a delegation registration.
    * Another dApp may use the weight to define the relative contribution each Role Key plays in a grouped registration.
    * The dApp is responsible for defining what the Weight means for a particular role.
    * If all weights are equal and convey no further meaning they can be elided to reduce the
      size of the registration metadata.
    * A dApp can specify if it is NOT valid to elide the Weight from a weighted role public key list.

Each dApp defines what is meant by a Role Key List.
They define if the List is weighted or not and how it is to be interpreted, in reference to the Role itself.

##### Simple Role Key List

```cbor
  [ <Role Public Key 1>, <Role Public Key 2>, ... ]
```

example:

```cbor
[ 
    h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C', 
    h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97'
]
```

##### Weighted Role Key List

```cbor
  [
    [ <Role Public Key 1>, <Weight 1> ],
    [ <Role Public Key 2>, <Weight 2> ],
    ...
  ]
```

example:

```cbor
[
  [h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C', 25],
  [h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97', 75]
]
```

#### Tooling

Supporting tooling should clearly define and differentiate this as a unique key type, describing such keys as "CIP-xx role keys".
When utilizing Bech32 encoding the appropriate `role_sk` and `role_vk` prefixes should be used as described in [CIP-05](https://github.com/cardano-foundation/CIPs/tree/master/CIP-0005)

Examples of acceptable `keyType`s for supporting tools:

| `keyType` | Description |
| --------- | ----------- |
| `CIP36RoleSigningKey_ed25519` | CIPxx Role Signing Key |
| `CIP36RoleVerificationKey_ed25519` | CIPxx Role Verification Key |

For hardware implementations:
| `keyType` | Description |
| --------- | ----------- |
| `CIP36RoleVerificationKey_ed25519` | Hardware CIPxx Role Verification Key |
| `CIP36RoleHWSigningFile_ed25519` | Hardware CIPxx Role Signing File |

### SubKey 2 - Stake Public Key

This is represented as a CBOR Byte-string, 32 bytes long.

This is the actual ed25519 Stake Public key of the wallet, and NOT the stake key public hash.
This is the primary key [
  [h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C', 25],
  [h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97', 75]
]associating the users wallet with their role key.
How the dApp uses this information is dApp specific.
For example Project Catalyst uses this information to derive voting power for a voter role.

It is an ed25519 public key, and is represented as a byte-string 32 bytes in length.
 Example:

```cbor
h'ad4b948699193634a39dd56f779a2951a24779ad52aa7916f6912b8ec4702cee'
```

### SubKey 3 - Payment Address (OPTIONAL)

This is represented as a CBOR Byte-string, Between 29 and 57 bytes long (inclusive).

If Present, this is a Shelley payment address as defined by [CIP-0019].
If must be discriminated for the same network this transaction is submitted to.
Its purpose is to enable a role registration to receive rewards.
How or what rewards can be earned are outside the scope of this CIP.

For CIP-15 compatibility ONLY,  in a CIP-15 format registration, a Stake Reward Address may also be present in Subkey 3.

This Subkey is optional, because not all roles will need or offer the ability to be earn rewards for the role.
In these cases, the payment address is redundant.
The dApp defines if this field is required or not for a particular role, and that is outside the scope of this CIP.

### SubKey 4 - Nonce

The `nonce` is an unsigned integer (of CBOR major type 0).

It SHOULD be monotonically rising across all transactions with the same staking key.
A simple way to ensure the `nonce` is monotonically increasing, without reference to the previous `nonce` is to use the the current slot number, at the time the transaction is created.

The `nonce` is specific to the dAPP UUID and Purpose.
The greatest `nonce` for any particular `dApp UUID` + `purpose` is the latest registration transaction, regardless of the order they are seen on the blockchain itself.

For example, given the following transactions for the same Stake Address:

| Slot No | Purpose | UUID | Nonce |
| ---     | ---     | ---  | ---   |
| 6128480 | 0       | h'ca7a195772774f8884dd5990f4c2ef95' | 6128420 |
| 6128500 | 0       | h'ca7a195772774f8884dd5990f4c2ef95' | 6128400 |
| 6128520 | 0       | h'ca7a195772774f8884dd5990f4c2ef95' | 6128380 |

The transaction in the earlier slot# 6128480 would be the latest of these 3 registrations, because it has the highest `nonce`.
 This can occur because it is possible for transactions in a small window of time to be added to a block in a different sequence to the one they were posted in.

The `nonce` when used correctly, therefore unambiguously defines the chronological order of the transactions.

In the event that a `nonce` is exactly the same in two or more registrations for the same dApp UUID/Purpose,  then the chronological order they appear in the blockchain determines which of the ambiguous `nonce` are the latest, for example:

| Slot No | Purpose | UUID | Nonce |
| ---     | ---     | ---  | ---   |
| 6128480 | 0       | h'ca7a195772774f8884dd5990f4c2ef95' | 6128420 |
| 6128500 | 0       | h'ca7a195772774f8884dd5990f4c2ef95' | 6128420 |
| 6128520 | 0       | h'ca7a195772774f8884dd5990f4c2ef95' | 6128420 |

The registration in Slot No 6128520 is the latest registration, because the `nonce` is unable to unambiguously define the chronological order the transactions were posted.

The dApp defines for every purpose what a `later` vs `older` registration means.
It is common that a later `nonce` obsoletes an earlier registration for the same purpose.

The full definition of registration validity and priority with respect to chronology of the transactions is outside the scope of this CIP and must be defined by every dApp which implements this specification.

### SubKey 5 - Purpose

The `purpose` is an unsigned integer (of CBOR major type 0).

Purpose defines the PURPOSE the registration transaction is for.
The dApp can define any number of purposes, and their definition is outside the scope of this specification.

The combination of a [dApp UUID][dApp-UUID] and Purpose defines a specific role registration for a dApp.7

For example,  in Project Catalyst Purpose 0 defines a Voter registration.

This specification is not limited to this definition for Purpose 0, and any other dApp may assign a different Purpose to Purpose 0, within its unique [dApp UUID][dApp-UUID].

### SubKey 6 - dApp UUID

This is represented as a CBOR Byte-string, 16 bytes long.

Each dApp that uses this specification MUST define a [Random V4 UUID](https://www.rfc-editor.org/rfc/rfc4122).
Other UUID version types are invalid.
Nil or MAX UUID V4 are also invalid and must not be used.
The Random UUID must be properly generated using a good quality RNG.

Briefly, the Display Format of a Valid V4 UUID is:

```uuid
xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
```

y has the bit pattern [10xxxxxx].

All `x` Bytes/Bits are randomly determined.

However, in the registration transaction it is always represented in its compact format of 128 bits (16 bytes).

It is recommended that dApps register their self allocated UUID in the following table.

UUID Registration:
| `UUID` | dApp Assigned | CIP Defining Roles |
| --------- | ----------- | --- |
| `ca7a1957-7277-4f88-84dd-5990f4c2ef95` | Project Catalyst UUID | CIP-62 |

However as the chance of a collision if a Random UUID is highly unlikely (103 Trillion Properly generated v4 UUID's have a 1 in 1 billion chance of collision.) this is not a requirement.

It is in the dApp implementors self interest to generate a good quality UUID to allow them to correctly distinguish their registrations vs those of another application.

### SubKey 7 - Expires (Optional)

The Expiry is represented by an unsigned integer (of CBOR major type 0) a maximum of 64 bits in size.

If the Expires sub key is not present, it defaults to 0.
The Expires subkey set to 0 = DO NOT EXPIRE.

Any other value defines the time, as an integer number of seconds since 1/1/1970 UTC.
Otherwise known as Unix Epoch time.
When the Unix Epoch time exceeds the Expires time, the registration should be considered obsolete or invalid.

For example an expires time of 1688169600 will be considered expired only after Saturday, July 1, 2023 0:00:00 UTC.

This allows dApps and Role registrations to be bounded by the creator of the registration ONLY.

Individual dApps will specify how exceeding Unix Epoch time effects the registration.
The dApp may define that expiry is not available, in which case this field will have no effect.
However, if it is supported by the dApp, it must be interpreted as defined here.

The dApp is also free to apply other "expiry" conditions to old registrations, and they are outside the scope of this specification.
For example,  a dApp may reject or ignore all registrations that were placed on chain more than 6 months before they are used, regardless of the setting of `expires`.

### SubKey 8-99 - Reserved

These subkeys are reserved and may not be used by a dApp that conforms to this specification.
If these keys are defined at a later date, they will de defined ina CIP which either updates or obsoletes this specification.

Any dApp which uses Subkeys 8-99 violates this CIP and is non-conformant.
However, a wallet should not reject the creation of a registration that violates this rule, to allow for future upgrades or amendments to the specification without necessitating tooling changes to support them.

### SubKey 100+ - dApp Defined Extended Metadata

Subkeys 100+ are available for dApp authors to add further metadata to registrations under this CIP.
The dApp author should clearly document what this metadata is, how it is represented and formatted.

It is valid for different extended metadata to be defined for different purposes for the same [dApp UUID][dApp-UUID].

Examples of extended metadata:

* Social Media contacts for a particular role.
* A Description of the person or group covered by the registration.
* Links to other systems with expanded information related to the registration.

The wallet when signing these registration transactions should not validate this metadata strictly.
If the wallet believes it is invalid, it can warn the user, but should still allow it to be signed.
This is because definition of this metadata is intentionally fluid to allow the dApp authors to add or remove optional metadata, and this should be able to occur without breaking supporting tooling.

### High level overview of the Role Registration witness data

## Rationale: how does this CIP achieve its goals?
<!-- The rationale fleshes out the specification by describing what motivated the design and what led to 
particular design decisions.
It should describe alternate designs considered and related work. 
The rationale should provide evidence of consensus within the community and discuss significant objections 
or concerns raised during the discussion.

It must also explain how the proposal affects the backward compatibility of existing solutions when applicable. 
If the proposal responds to a CPS, the 'Rationale' section should explain how it addresses the CPS, 
and answer any questions that the CPS poses for potential solutions.
-->

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria. Or `N/A` if not applicable. -->

## Copyright

This CIP is licensed under [CC-BY-4.0]

Code samples and reference material are licensed under [Apache 2.0]

[CC-BY-4.0]: https://creativecommons.org/licenses/by/4.0/legalcode
[Apache 2.0]: https://www.apache.org/licenses/LICENSE-2.0.html
[CBOR]: https://www.rfc-editor.org/rfc/rfc8949.html
[CBOR - Core Deterministic Encoding Requirements]: https://www.rfc-editor.org/rfc/rfc8949.html#section-4.2.1
