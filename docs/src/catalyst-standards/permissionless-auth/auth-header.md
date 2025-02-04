# Permission-less Authentication for Catalyst

<!-- cspell: words ftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsK -->

## Overview

There is a requirement to establish identity with the catalyst backend to provide secure and
contextual access to resources managed by project Catalyst.

For example, a query of a voter's current voting power, should provide that information from the voter's identity.

This provides better security and also simplifies API's because they can have implicit parameters based on
the verified identity of the user.

This document defines the format of the Authentication Token, and how it should be used.

## Token Format

The Authentication Token is based loosely on JWT.
It consists of an Authentication Header attached to every authenticated request.
The header contains a catalyst ID and a signature over that ID.

This token can be attached to either individual HTTP requests, or to the beginning of a web socket connection.

The authentication header is in the format:

```http
Authorization: Bearer catid.<catalyst_id>.<signature>
```

The `<catalyst id>` is a [Catalyst ID] with the following characteristics:

* `scheme` is omitted.
* `username` is not present.
* `nonce` is set correctly.
* role and rotation are not specified (defaults are always used, and not encoded)

An example of a valid ID is:

* `:173710179@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE`

An example token using this [Catalyst ID] is:

* `catid.:173710179@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE.<signature>`

### The Catalyst ID

The Catalyst ID encoded in this way consists of 3 key fields.

* `nonce`: The timestamp the Token was generated (time bounds potential replay attacks).
* `network`: Allows the ID to support registration on multiple blockchains.
* `Role 0 Public Key`: Allows the registration on chain to be uniquely identified.

The Catalyst ID is used to identify the on chain registration, which supplies the current Role 0 Public Key Certificate.
This identifies the Public Key used to sign the token.

***NOTE*** The [Catalyst ID] strictly identifies the initial Role 0 public key.
However, the token is signed with the latest **ACTIVE** Role 0 Public Key.
This May or May not be the same key as encoded in the token.
The authorizer is required to get the latest Role 0 Key from the identified
on-chain registration.
It is **IMPOSSIBLE** to validate the Token without the on-chain registration data.
Validation without reference to the on-chain registration is **INVALID** and
**INSECURE**.

This Token can be used to provide identifying information about the user to the consumer of the Token.

Such as:

* Stake Address
* Registered Payment Address
* The Identity of the issuer of the Certificate (Self Signed, or issued by an Authority).
* Other Roles keys they have registered.
* Or any other data attached to the registration.

#### Nonce

The `nonce` field of the [Catalyst ID] is used to prevent time-based replay attacks.
The backend will validate every `nonce` is within a permitted time windows.
This allows handling of both Clock Skew, and allows a `nonce` to be re-used for a short duration.

The permitted duration of this time window is defined by the backend.

### signature

Initially, the only supported signature algorithm is ED25519.

The signature is calculated over all bytes in the token up to an including the final `.`.  

For example, given the token:

* `catid.:173710179@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE.<signature>`

The signature would be over the string:

* `catid.:173710179@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE.`

The cryptography is defined with reference to the latest on-chain registration certificate for Role 0.
Without obtaining the referenced certificate from the registration, it is not possible to verify the token.

The binary signature is encoded using [Base64 URL][base64-url] and attached to the token.

## Backend processing of the token

The backend should:

1. Verify the Token starts with `catid.`.
   * IF it does not, return `401`.
2. Split the token on the last `.`.
    * This yields the `signature` separate from the token body.
    * Convert the Base64 URL value into binary.
      If this fails, return `401`.
    * ***NOTE***, It is possible and valid for the [Catalyst ID] to contain any number of `.`.
      Therefore, the only safe way to extract the signature component,
      is to use the **LAST** `.` in the token to identify the break.
3. Parse the text following `catid.` as a Catalyst ID.
   If this fails, return `401`.
4. Verify the Catalyst ID, is in `ID` format, and contains a `nonce`.
   If this fails, return `401`.
5. Verify the `network` is known and supported.
   If this fails, return `401`.
6. Verify the `role 0 key` in the token is in registered on the identified `network`, and get the registration details.
   If this fails, return `401`.
7. Verify the `nonce` is in the valid acceptable range.
   If this fails, return `403`.
8. Get the latest stable signing certificate registered for Role 0.
9. Verify the signature against the Role 0 Public Key and Algorithm identified by the certificate.
    Check signature length is correct for the defined algorithm,
    before checking if the signature is valid.
    If this fails, return `403`.
10. ***OPTIONAL*** IF authorization against latest unstable is supported:
    1. Get the latest unstable signing certificate registered for Role 0.
    2. Verify the signature against the Role 0 Public Key and Algorithm identified by the certificate.
        If this fails, return `403`.
11. Token is valid, provide validated credentials to the endpoint for further processing, as required.

***NOTE***, while it is possible to check the `nonce` before checking the identity of the token,
the check for `nonce` validity is conducted after validating the identity of the token.
This ensures that validation can authoritatively return 403 when `nonce` is incorrect,
which it cannot do before checking the registered identity exists.
Further, `nonce` is trivial to spoof, and also trivial to check.
Therefore, no processing time is saved against an attacker if the `nonce` is incorrect.
It is expected that an attacker would always get the `nonce` correct.
The only reason the `nonce` will be incorrect under valid circumstances is because it has expired,
but the identity is correct.

### Invalid Token Processing

The Backend should not disambiguate the 401 or 403 responses.

For a frontend that is acting honestly, the only error response it should expect is a `403`.
The front end should always process a 403 as meaning the `nonce` needs refreshing.

There is no reason why a front end acting honestly should encounter scenarios 1, 2 or 4.
Therefore, there is no reason to disambiguate the response types for a potential attacker.

***NOTE***: The backend will *TYPICALLY* only validate against the latest Role 0 key registered, that is stable.
i.e, has reached the final/immutable part of the blockchain.
However, depending on the security requirements of the backend or endpoint,
it may choose to accept *BOTH* the latest stable public key and a newly registered but unstable public key as authoritative.

The frontend *SHOULD* ensure that it is using the latest stable Role 0 key for signing the token.
It *SHOULD NOT*, use any newly published Role 0 key before it has reached finality.
The only exclusion from this suggestion is for a new registration where there is no previous stable Role 0 key.

### Handling Key Rotation

It is out of scope for this document to define a single mechanism for the Front End to determine that a new key is final.

However, one approach could be, when a new token is registered:

1. Use the public key before the newly registered one for signing the token.
2. If the FE receives a 403, then update the `nonce` to `now()`.
3. If the FE again received a 403, switch to the latest signing key.

If this still results in a 403, then repeat from step 1.

This approach can occur without user interaction for a brief period.
However, if this error persists, then some feedback should be given to the user that authentication is failing.

The logic of this approach is:

1. The backend will most likely report 403 if the Token is correct, but the `nonce` is expired.
   So, the front end should ensure the `nonce` is not expired by updating it to the current time.
2. If the front end is sure the `nonce` has not expired,
   then the only other reason the backend will reply with 403 is because the signature is invalid.
   This would indicate that the key used is incorrect.
   Therefore, the latest key published must have become stable.
   So, update to using the latest key.

As stated above, the backend may elect to use the latest or current stable key interchangeably.  
The backend may have different security requirements on multiple endpoints.
The process above should not result in a stable token being replaced by an unstable token prematurely.

The primary reason the backend may accept an unstable signing key,
is to allow endpoints to function quickly after registration of a new user.

This may be acceptable for informational endpoints.
However, endpoints which can change the users state may require the signing key to be stable.
Refer to any API using this Token for further information.
If it is not clearly documented that the endpoint will accept an unstable signing key, and on what circumstances,
then it must be assumed that the endpoint requires the latest stable signing key.

## Example Token

```token
catid.:173710179@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE.<signature>
```

The full token header would then be:
<!-- markdownlint-disable MD013-->
```http
Authorization: Bearer * catid.:173710179@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE.<signature>
```
<!-- markdownlint-enable MD013-->

[base64-url]: https://base64.guru/standards/base64url
[Catalyst ID]: https://input-output-hk.github.io/catalyst-libs/branch/feat_cat_kid_to_cat_id/architecture/08_concepts/rbac_id_uri/catalyst-id-uri/
