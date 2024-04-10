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
* Its equally important to ensure that registrations prove custody/ownership of certain on-chain identities,
  such as registered stake address or drep registration.
* Metadata in a transaction is inaccessible to plutus scripts.
* Wallets could present raw data to be signed to the user, and that makes the UX poor because the user would have difficulty
  knowing what they are signing.
* Wallets could be extended to recognize certain metadata and provide better UX but that shifts dApp UX to every wallet.
* Putting chain keys in metadata can be redundant if those keys are already in the transaction.
* Some authentication needs to change with regularity, such as authentication tokens to a backend service,
  and this would require potentially excessive wallet interactions.
  This would lower UX quality and could impact participation.

The proposal here is to register dApp specific keys and identity, but strongly associate it with on-chain identity,
such as Stake Public Keys, Payment Keys and Drep Keys, such that off chain interactions can be fully authenticated,
and only on-chain interaction requires interaction with a Wallet.

## Specification

Role registration is encapsulated inside a [x509 Envelope](../x509-envelope-metadata/cip-xxxx.md) metadata record.
This enables the data to both be compressed, saving on-chain space and also to have more expressivity and
less restrictions vs raw on-chain metadata.

This specification covers the general use of the x509 registration format and is not specific to any dApp.
dApps can utilize any subset of the features defined herein, and dApps define their own roles.

In order to maintain a robust set of role registration capabilities Role registration involves:

1. Creation of a root certificate for a user or set of users and associating it with an on-chain source of trust.
2. Obtaining for each user of a dapp, or a set of users, their root certificate.
3. Deriving role specific keys from the root certificate.
4. Optionally registering for those roles on-chain.
5. Signing and/or encrypting data with the root certificate or a derived key, or a certificate issued by a previously
   registered root certificate.

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

x.509 certificates can be encoded in:

* Binary DER format
* [CBOR Encoded X.509 Certificates][C509].

### Metadata Structure

The formal definition of the x509 certificate payload is [here](./x509-roles.cddl).

The format can be visualized as:

![x509 Registration Format](./images/x509-roles.svg)

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

1. An [optional list](#x509-certificate-lists) of DER format x509 certificates.
2. An [optional list](#x509-certificate-lists) of [CBOR Encoded X.509 Certificates][C509]
3. An [optional list](#simple-public-keys) list of tagged simple public keys.
4. An [optional certificate revocation](#certificate-revocation-list) set.
5. An optional set of role registration data.

### x509 Certificate Lists

There can be two lists of certificates.
They are functionally identical and differ only in the format of the certificate itself.

DER Format certificates are used when the only certificate source is a legacy off-chain certificate.
These are not preferred because they can be transcoded into c509 format, and are usually larger than their c509 equivalent.
However, it is recognized that legacy support for x509 DER format certificates is important, and they are supported.

Preferably all certificates will either be uniquely encoded as c509 encoded certificates,
or will be transcoded from a DER format x509 certificate into it's c509 equivalent.

The certificate lists are unsorted, and are simply a method of publishing a new certificate on-chain.

The only feature about the certificate that impacts the role registration is that certificates
may embed references to on-chain keys.

In the case where a certificate does embed a reference to an on-chain key,
the key SHOULD be present in the witness set of the transaction.
Individual dApps can strengthen this requirement to MUST.

By including the Signature in the transaction, we are able to make a verifiable link between the
off-chain certificate and the on-chain identity.
This can not be forged.

### Simple Public Keys

Rather than require full certificates, dApps can use simple public keys.
The simple public key list is for that purpose.
The list acts as an array,  the index in the array is the offset of the key.

CBOR allows for array elements to be skipped or marked as undefined.

The actual set of simple public keys registered is the union set of all simple public keys registered on-chain.
This allows simple public keys to be securely rotated or removed from a registration.

CBOR allows elements of an array to be skipped or marked as absent using [CBOR Undefined/Absent Tags].

An element in the array marked "undefined" (`0xf7`) is used to indicate that no change to that array position is to be made.
An element in the array marked "absent" (`0xd8 0x1f 0xf7`) is used to indicate that any key at this position is revoked.

Using these two element we can define the array as the union of all arrays and keys can be freely altered or removed.

Examples:

```txt
[Key 1, Key 2, Key 3] +
[undefined, absent, undefined]
```

would result in:

```txt
[Key 1, undefined, Key 3]
```

If this was followed with:

```txt
[undefined, undefined, undefined, undefined, Key 5]
```

we would then have the resultant set of keys:

```txt
[Key 1, undefined, Key 3, undefined, Key 5]
```

The latest key set is what is currently active for the role.

These keys are usable to sign data for a role, but are not a replacement for certificates, and some roles may not allow their use.

### Certificate Revocation List

The certificate revocation list is used by an `issuer` of a certificate to revoke any certificate they have issued.
The certificate is considered revoked as soon as it appears in the revocation list.
If a self signed certificate is to be rolled, a registration will revoke the previously self signed certificate and
simultaneously register a new certificate.

This ensures that the roles registered always have a valid certificate and allows registration to be dynamically updated.

The revocation list is simply a list of blake2b-128 hashes of the certificate/s to be revoked.
Note, as stated above the only party that can revoke a certificate is the issuer, so the metadata must be posted by the issuer using
their own role 0 key.

Any certificate that is revoked which was used to issue other certificates results in ALL certificates issued by the
revoked certificate also being revoked.

### Role definitions

Roles are defined in a list.
A user can register for any available role, and they can enrol in more than one role in a single registration transaction.

The validity of the registration is as per the rules for roles defined by the dApp itself.

Role registration data is further divided into:

1. [A Role number](#role-number)
2. An Optional reference to the roles signing key
3. An Optional reference to the roles encryption key
4. An optional reference to the on-chain payment key to use for the role.
5. And an optional dApp defined set of role specific data.

#### Role Number

All roles, except for Role 0, are defined by the dApp.

Role 0 is the primary role and is used to sign the metadata.
All compliant implementations of this specification use Role 0 in this way.

#### Reference to a role signing key

Each role can optionally be used to sign data.
If the role is intended to sign data, the key it uses to sign must be declared in this field.
This is a reference to either a registered certificate for the identity posting the registration,
or one of the defined simple public keys.

A dApp can define is roles allow the use of certificates, or simple public keys, or both.

Role 0 MUST have a signing key, and it must be a certificate.

A reference to a key/certificate can be a cert in the same registration, or any previous registration.
If the certificate is revoked, the role is unusable for signing unless and until a new signing certificate
is registered for the role.

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

## Path to Active

### Acceptance Criteria

### Implementation Plan

## References

## Copyright

This CIP is licensed under [CC-BY-4.0]

Code samples and reference material are licensed under [Apache 2.0]

[CC-BY-4.0]: https://creativecommons.org/licenses/by/4.0/legalcode
[Apache 2.0]: https://www.apache.org/licenses/LICENSE-2.0.html
[CBOR]: https://www.rfc-editor.org/rfc/rfc8949.html
[CBOR - Core Deterministic Encoding Requirements]: https://www.rfc-editor.org/rfc/rfc8949.html#section-4.2.1
[C509]: https://datatracker.ietf.org/doc/html/draft-ietf-cose-cbor-encoded-cert-07
[CBOR Undefined/Absent Tags]: https://github.com/svaarala/cbor-specs/blob/master/cbor-absent-tag.rst
