# Content

* [Content](#content)
  * [Features](#features)
  * [Requirements](#requirements)
  * [Install](#install)
  * [Web setup](#web-setup)
  * [Example](#example)
  * [Limitations](#limitations)
  * [Reference documentation](#reference-documentation)
  * [Support](#support)
  * [License](#license)

## Features

This package implements [CIP-30](https://cips.cardano.org/cip/CIP-30) and
[CIP-95](https://cips.cardano.org/cip/CIP-95) APIs which allow the Flutter web app to communicate
with the Cardano wallet extension.

In short, the package exposes window.{walletName} JS api taking
away all the complexities of using js_interop.

## Requirements

* Dart: 3.5.0+
* Flutter: 3.29.0+

## Install

```yaml
dependencies:
    catalyst_cardano_serialization: any # or the latest version on Pub
    catalyst_cardano: any # or the latest version on Pub
    catalyst_cardano_web: any # or the latest version on Pub
    catalyst_key_derivation: any # or the latest version on Pub
```

## Web setup

Add the following line at the end of `<head>` section in web/index.html:

```html
<script type="module" src="/assets/packages/catalyst_cardano_web/assets/js/catalyst_cardano.js"></script>
```

## Example

Import `package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart`
and `package:catalyst_cardano/catalyst_cardano.dart`, instantiate `TransactionBuilder`,
provide transaction inputs, outputs, add change address for any remaining unspent UTXOs
and build the transaction body.

To obtain the `witnessSet` call `api.signTx(transaction: unsignedTx);`.
Finally, create a signed transaction and submit it
to the blockchain with `api.submitTx(transaction: signedTx);`

```dart
import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';

Future<void> main() async {
  await CatalystKeyDerivation.init();

  final wallets = await CatalystCardano.instance.getWallets();
  if (wallets.isEmpty) {
    // no wallet extension found, please install in your browser
    return;
  }

  final wallet = wallets.first;
  print(wallet.name);
  print(wallet.icon);
  print(wallet.apiVersion);
  print(wallet.supportedExtensions);

  final api = await wallet.enable();
  assert(await wallet.isEnabled(), 'wallet is enabled');

  print(await api.getBalance());
  print(await api.getExtensions());
  print(await api.getNetworkId());
  print(await api.getRewardAddresses());
  print(await api.getUnusedAddresses());
  print(await api.getUsedAddresses());

  final unsignedTx = _buildUnsignedTx(
    utxos: await api.getUtxos(
      amount: const Balance(
        coin: Coin(1000000),
      ),
    ),
    changeAddress: await api.getChangeAddress(),
  );

  final witnessSet = await api.signTx(transaction: unsignedTx);
  final signedTx = Transaction(
    body: unsignedTx.body,
    isValid: true,
    witnessSet: witnessSet,
  );
  await api.submitTx(transaction: signedTx);
}

Transaction _buildUnsignedTx({
  required Set<TransactionUnspentOutput> utxos,
  required ShelleyAddress changeAddress,
}) {
  const txBuilderConfig = TransactionBuilderConfig(
    feeAlgo: TieredFee(
      constant: 155381,
      coefficient: 44,
      refScriptByteCost: 15,
    ),
    maxTxSize: 16384,
    maxValueSize: 5000,
    coinsPerUtxoByte: Coin(4310),
  );

  /* cSpell:disable */
  final preprodFaucetAddress = ShelleyAddress.fromBech32(
    'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
  );
  /* cSpell:enable */

  final txOutput = TransactionOutput(
    address: preprodFaucetAddress,
    amount: const Balance(coin: Coin(1000000)),
  );

  final txBuilder = TransactionBuilder(
    config: txBuilderConfig,
    inputs: utxos,
    networkId: NetworkId.testnet,
  );

  final txBody = txBuilder
      .withOutput(txOutput)
      .withChangeAddressIfNeeded(changeAddress)
      .buildBody();

  return Transaction(
    body: txBody,
    isValid: true,
    witnessSet: const TransactionWitnessSet(vkeyWitnesses: {}),
  );
}
```

## Limitations

This package supports a minimal `TransactionBuilder` that does not yet work with
Smart Contracts or scripts.
However AuxiliaryMetadata is already supported thus it's possible to fulfill some of the use cases.
NFTs are partially supported, i.e. to transfer them in a transaction.

Only Shelley era bech32 base and stake addresses are supported.
Byron era addresses are not supported.

## Reference documentation

* [Cardano transaction specification](https://github.com/input-output-hk/catalyst-CIPs/blob/x509-rbac-signing-with-cip30/CIP-XXXX/README.md#specification)
* [Cardano Multiplatform Lib](https://github.com/dcSpark/cardano-multiplatform-lib) with reference
implementation for fee calculation algorithm and change address management.

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
