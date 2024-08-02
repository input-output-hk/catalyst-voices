# Content

* [Content](#content)
  * [Features](#features)
  * [Requirements](#requirements)
  * [Install](#install)
  * [Web setup](#web-setup)
  * [Example](#example)
  * [Limitations](#limitations)
  * [Support](#support)
  * [License](#license)

## Features

This package exposes a CBOR Object Signing and Encryption
[RFC-8152](https://datatracker.ietf.org/doc/html/rfc8152) implementation of cose-js npm module.

* [cose-js](https://www.npmjs.com/package/cose-js)

## Requirements

* Dart: 3.3.4+
* Flutter: 3.22.1+

## Install

```yaml
dependencies:
    catalyst_cose: any # or the latest version on Pub
    catalyst_cose_web: any # or the latest version on Pub
```

## Web setup

Add the following line at the end of `<head>` section in web/index.html:

```html
<script type="module" src="/assets/packages/catalyst_cose_web/assets/js/catalyst_cose.js"></script>
```

## Example

```dart
// ignore_for_file: avoid_print

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:convert/convert.dart';

Future<void> main() async {
  final message = hex.decode(
    '6c1382765aec5358f117733d281c1c7bdc39884d04a45a1e6c67c858bc206c19',
  );

  final coseSignature = await CatalystCose.instance.signMessage(message);
  print(coseSignature);
}
```

## Limitations

This package supports only web platform at the moment but it's intended that other platforms are supported in the future.

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
