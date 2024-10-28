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
    // ignore: avoid_print
    print(await greet(name: 'Tom'));
  }
}
