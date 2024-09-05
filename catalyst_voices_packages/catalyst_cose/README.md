# Content

* [Content](#content)
  * [Features](#features)
  * [Requirements](#requirements)
  * [Install](#install)
  * [Example](#example)
  * [Limitations](#limitations)
  * [Support](#support)
  * [License](#license)

## Features

This package exposes a CBOR Object Signing and Encryption
[RFC-9052](https://datatracker.ietf.org/doc/html/rfc9052),
[RFC-9053](https://datatracker.ietf.org/doc/html/rfc9053) implementation.

## Requirements

* Dart: 3.5.0+

## Install

```yaml
dependencies:
    catalyst_cose: any # or the latest version on Pub
```

## Example

```dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

Future<void> main() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(List.filled(32, 0));
  final privateKey = await keyPair.extractPrivateKeyBytes();
  final publicKey = await keyPair.extractPublicKey().then((e) => e.bytes);

  final payload = utf8.encode('This is the content.');

  final coseSign1 = await CatalystCose.sign1(
    privateKey: privateKey,
    payload: payload,
    kid: CborBytes(publicKey),
  );

  final verified = await CatalystCose.verifyCoseSign1(
    coseSign1: coseSign1,
    publicKey: publicKey,
  );

  print('COSE_SIGN1:');
  print(hex.encode(cbor.encode(coseSign1)));
  print('verified: $verified');

  assert(
    verified,
    'The signature proves that given COSE_SIGN1 structure has been '
    'signed by the owner of the given public key',
  );
}
```

## Limitations

This package supports only a subset of COSE features and algorithms.
More features and algorithms are supposed to be added in the feature.

Supported features:

* COSE_SIGN_1: signature + verification

Supported algorithms:

* EdDSA: Ed25519

## Support

Post issues and feature requests on the GitHub [issue tracker](https://github.com/input-output-hk/catalyst-voices/issues).
Please read our [CONTRIBUTING](https://github.com/input-output-hk/catalyst-voices/blob/main/CONTRIBUTING.md)
for guidelines on how to contribute.

## License

Licensed under either of [Apache License, Version 2.0](https://github.com/input-output-hk/catalyst-voices/blob/main/LICENSE-APACHE)
or [MIT license](https://github.com/input-output-hk/catalyst-voices/blob/main/LICENSE-MIT)
at your option.

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this crate by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.
