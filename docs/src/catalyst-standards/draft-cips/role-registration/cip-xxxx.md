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

| Label | Description |
| ---   | --- |
| 72220 | The RBAC Metadata Label |
| 72221 | The RBAC Metadata witness set Label |

Both pieces of metadata must be present for the registration to be valid.

Note: **7222 is RBAC when decoded using the telephone ITU E.161 standard**

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
