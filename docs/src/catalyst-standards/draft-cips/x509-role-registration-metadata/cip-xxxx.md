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

## Abstract

dApps such as Project Catalyst need robust, secure and extensible means for users to register under various roles
and for the dApp to be able to validate actions against those roles with its users.

While these Role based registrations are required for future functionality of Project Catalyst, they are also
intended to be generally useful to any dApp with User roles.

## Motivation: why is this CIP necessary?

CIP-36 contains a limited form of role registration limited to voters and dreps.

However, Project Catalyst has a large (and growing) number of roles identified in the system, all of
which can benefit from on-chain registration.

A non-exhaustive example list of the roles Project Catalyst needs to identify securely are:

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
CIP is to allow the user to unambiguously assert they are acting in the capacity of a selected role.

CIP-36 offers a "purpose" field, but offers no way to manage it, and offers no way to allow it to be used unambiguously.
The "purpose" field therefore is insufficient for the needs of identifying roles.

CIP-36 also does not allow the voting key to be validated.
This makes it impossible to determine if the registration voting key is usable, and owned by the registering user, or has
been duplicated from another registration on-chain or is just a random number.

It also offers no way to identify the difference between a voter registering for themselves, and a voter registering to be a dRep.

These are some of the key reasons, CIP-36 is insufficient for future Project Catalyst needs.

Registering for various roles and having role specific keys is generally useful for dApps, so while this CIP is
motivated to solve problems with Project Catalyst, it is also intended to be generally applicable to other dApps.

There are a number of interactions with a user in a dApp like Catalyst which require authentication.
However forcing all authentication through a wallet has several primary disadvantages.

* Wallets only are guaranteed to provide `signData` if they implement CIP30, and that only allows a single signature.
* There are multiple keys controlled by a wallet and its useful to ensure that all keys reflected are valid.
* Metadata in a transaction is inaccessible to plutus scripts.
* Wallets could present raw data to be signed to the user, and that makes the UX poor because the user would have difficulty
  knowing what they are signing.
* Wallets could be extended to recognize certain metadata and provide better UX but that shifts dApp UX to every wallet.
* Putting chain keys in metadata can be redundant if those keys are already in the transaction.
* Some authentication needs to change with regularity, such as authentication tokens to a backend service,
  and this would require potentially excessive wallet interactions.

The proposal here is to register dApp specific keys and identity, but strongly associate it with on-chain identity,
such as Stake Public Keys, Payment Keys and Drep Keys, such that off chain interactions can be fully authenticated,
and only on-chain interaction requires interaction with a Wallet.

## Specification

In order to maintain a robust set of role registration capabilities Role registration involves:

1. Creation of a root certificate for a user or set of users and associating it with an on-chain source of trust.
2. Obtaining for each user of a dapp, or a set of users, their root certificate.
3. Deriving role specific keys from the root certificate.
4. Optionally registering for those roles on-chain.
5. Signing and/or encrypting data with the root certificate or a derived key, or a certificate issued by a previously registered root certificate.

Effectively we map the blockchain as PKI (Public Key Infrastructure) and define the methods a dapp can use to exploit this PKI.

### Mapping the PKI to Cardano

A PKI consists of:

* A certificate authority (CA) that stores, issues and signs the digital certificates;
  * Each dApp *MAY* control its own CA,  the user trusts the dApp as CA implicitly (or explicitly) by using the dApp.
  * It is also permissible for root certificates to be self signed, effectively each user becomes their own CA.
  * However all Certificates are associated with blockchain addresses, typically one or more Stake Public Key.
    * A certificate could be associated with multiple Stake Addresses, Payment Addresses or DRep Public Keys, as required.
  * A dApp may require that a well known public CA is used.  
  The chain of trust can extend off chain to centralized CAs.
  * DAOs or other organizations can also act as a CA for their members.
  * This is intentionally left open so that the requirements of the dApp can be flexibly accommodated.
* A registration authority (RA) which verifies the identity of entities requesting their digital certificates
  to be stored at the CA;
  * Each dApp is responsible for identifying certificates relevant for its use that are stored on-chain and are their own RA.
  * The dApp may choose to not do any identifying.
  * The dApp can rely on decentralized identity to verify identity in a trustless way.
* A central directory—i.e., a secure location in which keys are stored and indexed;
  * This is the blockchain itself.
  * As mentioned above, the chain of trust can extend off-chain to traditional Web2 CA's.
* A certificate management system managing things like the access to stored certificates or the delivery of the
  certificates to be issued;
  * This is managed by each dApp according to its requirements.
* A certificate policy stating the PKI's requirements concerning its procedures.
  Its purpose is to allow outsiders to analyze the PKI's trustworthiness.
  * This is also defined and managed by each dApp according to its requirements.

### The role x.509 plays in this scheme

We leverage the x.509 PKI primitives.
We intentionally take advantage of the significant existing code bases and infrastructure which already exists.

#### Certificate formats

x.509 certificates can be encoded in

We encode x.509 certificates using [CBOR Encoded X.509 Certificates][C509], Each certificate includes its on-chain anchor (public key).
The on-chain anchors currently envisioned are:

1. Stake Address
2. dRep Key

The transaction that is submitted on-chain which includes the certificate in its metadata MUST be witnessed by it's on-chain anchor.
This is used to prove that the certificate and on-chain anchor are controlled by the same entity.
It prevents replay attacks where people could try and associate a different on-chain anchor with a certificate.

---

Note: **The information below is to be reviewed in-light of the above**

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
2. A [stake address for the network that this transaction is submitted to](#subkey-2---stake-public-key);
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
  1: #6.32773(h'a6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663') ; or
     [#6.32773(h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C'), 
      #6.32773(h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97')] ; or
     [
      [#6.32773(h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C'), 50], 
      [#6.32773(h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97'), 50]
     ]
  // Stake Public Key
  2: #6.32773(h'ad4b948699193634a39dd56f779a2951a24779ad52aa7916f6912b8ec4702cee'),
  // Payment Address
  3: #6.???h'00588e8e1d18cba576a4d35758069fe94e53f638b6faf7c07b8abd2bc5c5cdee47b60edc7772855324c85033c638364214cbfc6627889f81c4',
  // nonce
  4: #6.32770 h'018d45d8deb3a1b171f6b38577ecee20',     // ULID
  // Role
  5: 0,
  // dApp ID (UUID or ULID)
  6: #6.37    h'a3c12b1c98af4ee8b54278e77906c0fc'; or  // UUID
     #6.32770 h'018d1d2acaf04486be189dbc5ae35e51',     // ULID
  // Expires - Optional
  7: #6.1(0),
  // dApp Defined Metadata - Optional
  100+: <Any>
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
* A [Optionally Weighted List of Role Specific Public Keys](#subkey-1---role-key---list-of-role-keys).

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
The [dApp ID] is 128 bits.  
It is required that the Role key be, as far as practically possible, unique amongst dApps.
This is to prevent a Role from one dApp being misused by another, either intentionally or inadvertently.

However key derivation is limited to 31 bits, accordingly, the [dApp ID] will be hashed with Blake2B and a
31 bit digest will be produced.
The aim is to as far as practical cause dApps to have distinct Role keys under normal circumstances.

`m / 7222' / 1815' / account' / chain' / hash(dApp ID) / role`

* `7222'` : The registration metadata field key from this CIP.
* `1815'` : The year Ada Lovelace was born - Identifies this key as being for Cardano.
* `account'` : The voters account
* `chain'` : The chain on which the voter is registering.
* `hash(dapp ID)` : The [hashed](#hashdapp-id) [dApp ID]
* `role` :  The role being registered for.

Note: It is specifically required that the Role Key NOT CHANGE for the same dApp UUID/Purpose for any compliant Wallet.
This is because its possible to make both single and array role registrations, and its critical the key be the same in these.
It also critical that the Role keys be freely transferable and recoverable across wallets.
The necessity of this will be expanded on when the witness is discussed below.

##### hash(dapp ID)

The [dApp ID] will be reduced to 31 bits by using Blake2B with a 32 bit digest over the [dApp ID].

To ensure the hardening bit is not set, the high bit of the resultant hash will be forced to 0.

```text
  hash(dapp ID) == blake2b_32(dapp ID) & 0x7FFFFFFF
```

While 31 bits is small, and could be subject to a collision attack, the intention here is not to prevent
deliberately contrived collisions but to disambiguate dApps under normal circumstances.
As the [dApp ID] is not controllable, a malicious dApp could simply use the same dApp ID as another.
Therefore it is not possible to protect against a collision and the [dApp ID] is not a security mechanism
in any event.

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

### SubKey 2 - Stake Public Key

This is represented as a CBOR Byte-string, 32 bytes long.

This is the actual [ED25519-BIP32] Stake Public key of the wallet, and NOT the stake key public hash.
This is the primary key associating the users wallet with their role key.
How the dApp uses this information is dApp specific.
For example Project Catalyst can use this information to derive voting power for a voter role.

It is an ed25519 public key, and is represented as a byte-string 32 bytes in length.
 Example:

```cbor
#6.32773(h'ad4b948699193634a39dd56f779a2951a24779ad52aa7916f6912b8ec4702cee')
```

Note: There can only be a single Stake Public Key in the registration.
Multiple Stake Public Keys can be associated with the same Role Key/s, however there needs to be one registration per stake address.

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

## References

## Copyright

This CIP is licensed under [CC-BY-4.0]

Code samples and reference material are licensed under [Apache 2.0]

[CC-BY-4.0]: https://creativecommons.org/licenses/by/4.0/legalcode
[Apache 2.0]: https://www.apache.org/licenses/LICENSE-2.0.html
[CBOR]: https://www.rfc-editor.org/rfc/rfc8949.html
[CBOR - Core Deterministic Encoding Requirements]: https://www.rfc-editor.org/rfc/rfc8949.html#section-4.2.1
[CIP0003]: https://cips.cardano.org/cip/CIP-0003
[C509]: https://datatracker.ietf.org/doc/html/draft-ietf-cose-cbor-encoded-cert-07
