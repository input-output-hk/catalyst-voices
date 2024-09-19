# Permission-less Authentication for Catalyst

## Overview

There is a requirement to establish identity with the catalyst backend to provide secure and
contextual access to resources managed by project Catalyst.

For example, a query of a voter's current voting power, should provide that information from the voter's identity.

This provides better security and also simplifies API's because they can have implicit parameters based on
the verified identity of the user.

This document defines the format of the Authentication Token, and how it should be used.

## Token Format

The Authentication Token is based loosely on JWT.
It consists of an Authentication Header attached to every authenticated request, and an encoded signed.

This token can be attached to either individual HTTP requests, or to the beginning of a web socket connection.

The authentication header is in the format:

```http
Authorization: Bearer catv1.<encoded token>
```

The `<encoded token>` is a [base64-url] encoded binary token whose format is defined in
[auth-token.cddl](./auth-token.cddl).

### Encoded Binary Token Format

The Encoded Binary Token is a [CBOR sequence] that consists of 3 fields.

* `kid` : The key identifier.
* `ulid` : A ULID which defines when the token was issued, and a random nonce.
* `signature` : The signature over the `kid` and `ulid` fields.

#### kid

The Key ID is used to identify the Public Key Certificate, which identifies the Public Key used to sign the token.
Because this certificate is the Role 0 Certificate from the on-chain Role-Based Access Control specification,
it can be used to also provide identifying information about the user.
Such as:

* Stake Address
* Registered Rewards Address
* The Identity of the issuer of the Certificate (Self Signed, or issued by an Authority).
* Other Roles keys they have registered.
* Or any other data attached to the registration.

The `kid` is simply the Blake2b-128 hash of the Role 0 Certificate.

The backend will use this hash to identify the certificate from the on-chain registration and use
that information to both authenticate the user and provide identifying information about them to the
backend.

#### ulid

A standard [ULID] will be created when the token is first issued.
The [ULID] contains a timestamp of when it was created, and a random nonce.
The timestamp is used to protect against replay attack by allowing the backend to reject
authentication if the timestamp is too old (or too far into the future).

#### signature

Initially, the only supported signature algorithm is ED25519.
However, the KID could in-future refer to a certificate which uses different cryptography.
Accordingly, the formal specification of the signature is that it is as many bytes as required to
embed a signature of the type defined by the certificate identified by the `kid`.

For ED25519, the signature will be 64 bytes.

## Example Token

The [CDDL Specification](./auth-token.cddl) contains an example token.
This is binary.

The binary of that example is:

```hex
50 00 11 22 33 44 55 66 77 88 99 AA BB CC DD EE FF
50 01 91 2C EC 71 CF 2C 4C 14 A5 5D 55 85 D9 4D 7B
58 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
```

[base64-url] encoded it becomes:

<!-- cspell: words UAAR NEVWZ Jmqu QAZEs HHPL Vhdl -->
```base64
UAARIjNEVWZ3iJmqu8zd7v9QAZEs7HHPLEwUpV1VhdlNe1hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

The full token header would then be:
<!-- markdownlint-disable MD013-->
```http
Authorization: Bearer catv1.UAARIjNEVWZ3iJmqu8zd7v9QAZEs7HHPLEwUpV1VhdlNe1hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```
<!-- markdownlint-enable MD013-->

* [base64-url] <https://base64.guru/standards/base64url>
* [CBOR sequence] <https://www.rfc-editor.org/rfc/rfc8742.html>
* [ULID] <https://github.com/ulid/spec>
