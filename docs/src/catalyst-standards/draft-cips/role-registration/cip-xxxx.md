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

1. A [role public key or non-empty group of role public keys]();
2. A [stake address for the network that this transaction is submitted to]();
3. An *Optional* [Shelley payment address]().
4. A [nonce]() that identifies that most recent registration.
5. The [purpose]() of the registration.
6. A [dApp ID]() which defines the dApp the registration belongs to.
6. An *Optional* [expiry timestamp]().
7. Optional dApp defined [extended registration metadata]().

The formal specification for the `7222` Metadata is [CIPxxxx Metadata CDDL][].

Informally, all Registrations follow the same generalized Format:

```cbor
7222: {
  // Role Public Key or Role Public Key Array
  1: h'a6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663' or ,
     [[h'A71A8700248D4C91E01A2A2CB5F4F0E664F084EB761C6792AEDD28160C1E403C', 50], [h'C606D983C5545800FAF20519D21988AA0A13271BA12BA9A8643FCFAD58697C97', 50]]
  // Stake Public Key
  2: h'ad4b948699193634a39dd56f779a2951a24779ad52aa7916f6912b8ec4702cee',
  // Payment Address
  3: h'00588e8e1d18cba576a4d35758069fe94e53f638b6faf7c07b8abd2bc5c5cdee47b60edc7772855324c85033c638364214cbfc6627889f81c4',
  // nonce
  4: 5479467,
  // Purpose
  5: 0,
  // dApp ID
  6: h'',
  // Expires - Optional
  7: 0,
  // dApp Defined Metadata - Optional
  100: <Any>
}
```

Keys between `8` and `99` are reserved for any future extensions to this specification.
They must not be defined by any dApp for private use.
These 

Keys above `100` are reserved for dApp specific use, and may be defined either formally or informally by any dApp.
General parsers of this data should accept, but not otherwise interpret keys `100`+ unless they specifically understand
the requirements of the identified dApp.

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
