# Content

* [Content](#content)
  * [Features](#features)
  * [References](#references)
  * [Requirements](#requirements)
  * [Install](#install)
  * [Web setup](#web-setup)
  * [Example](#example)
  * [How to contribute changes](#how-to-contribute-changes)
  * [Support](#support)
  * [License](#license)

## Features

This package exposes BIP32-Ed25519 Cardano HD Key Derivation for Flutter (SLIP-0023).

The underlying implementation is written in rust and translated to Flutter
via the [flutter_rust_bridge](https://pub.dev/packages/flutter_rust_bridge).

## References

* [BIP32-Ed25519](https://input-output-hk.github.io/adrestia/static/Ed25519_BIP.pdf)
* [SLIP-0023](https://github.com/satoshilabs/slips/blob/master/slip-0023.md)
* [BIP-0032](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)
* [flutter_rust_bridge](https://pub.dev/packages/flutter_rust_bridge)

## Requirements

* Dart: 3.5.0+
* Flutter: 3.24.1+

## Install

```yaml
dependencies:
    catalyst_key_derivation: any # or the latest version on Pub
```

## Web setup

[flutter_rust_bridge](https://pub.dev/packages/flutter_rust_bridge) requires custom cross origin
headers in order to enable sharing buffer across origins.

* When running the app via `flutter run` follow:
[#when-flutter-run](https://cjycode.com/flutter_rust_bridge/manual/miscellaneous/web-cross-origin#when-flutter-run)
* When deploying the app via a web server make sure to setup these headers from your server:
[web-cross-origin#background](https://cjycode.com/flutter_rust_bridge/manual/miscellaneous/web-cross-origin#background)

## Example

```dart
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';

Future<void> main() async {
  // init has to be called once per app lifetime before the package could be used
  await CatalystKeyDerivation.init();

  const keyDerivation = CatalystKeyDerivation();

  final xprv = await keyDerivation.deriveMasterKey(
    mnemonic: 'prevent company field green slot measure chief'
        ' hero apple task eagle sunset endorse dress seed',
  );
  print('Master xprv ${xprv.toHex()}');

  final xpub = await xprv.derivePublicKey();
  print('Master xpub ${xpub.toHex()}');

  final data = [1, 2, 3, 4];
  final sig = await xprv.sign(data);

  final checkXprvSig = await xprv.verify(data, signature: sig);
  print('Check signature by using xprv $checkXprvSig');

  final checkXpubSig = await xpub.verify(data, signature: sig);
  print('Check signature by using xpub $checkXpubSig');

  const path = "m/1852'/1815'/0'/2/0";
  final childXprv = await xprv.derivePrivateKey(path: path);
  print('Derive xprv with $path: ${childXprv.toHex()}');

  final childXprvHex = childXprv.toHex();
  print('Child xprv hex $childXprvHex');

  xprv.drop();
  print('Master xprv dropped ${xprv.toHex()}');
}
```

## How to contribute changes

[flutter_rust_bridge](https://pub.dev/packages/flutter_rust_bridge) is used as a bridge between Rust and Flutter.
To add/update existing functionality offered by this package follow these steps:

1. [Setup flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/quickstart)
2. Make changes to Rust code in /rust/src/*
3. Generate Flutter bindings via [earthly](https://earthly.dev/): `earthly +code-generator --local true`
4. Update Flutter code that references Rust exposed API
5. Commit your changes and raise a PR

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
