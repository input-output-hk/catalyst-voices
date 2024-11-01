// ignore_for_file: avoid_print

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _doMagic,
                child: const Text(
                  'Action: Call',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doMagic() async {
    final xprv = await mnemonicToXprv(
      mnemonic: 'prevent company field green slot measure chief'
          ' hero apple task eagle sunset endorse dress seed',
    );
    print('Master xprv ${xprv.inner}');

    final xpub = await xprv.xpublicKey();
    print('Master xpub ${xpub.inner}');

    final data = [1, 2, 3, 4];
    final sig = await xprv.signData(data: data);

    final checkXprvSig = await xprv.verifySignature(data: data, signature: sig);
    print('Check signature by using xprv $checkXprvSig');

    final checkXpubSig = await xpub.verifySignature(data: data, signature: sig);
    print('Check signature by using xpub $checkXpubSig');

    const path = "m/1852'/1815'/0'/2/0";
    final childXprv = await xprv.deriveXprv(path: path);

    print('Derive xprv with $path: ${childXprv.inner}');

    xprv.drop();
    print('Master xprv dropped ${xprv.inner}');
  }
}
