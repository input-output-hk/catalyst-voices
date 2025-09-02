import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<int>> _brotliFuture;
  final data = List.generate(1024, (i) => i % 255);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Center(
          child: FutureBuilder(
            future: _brotliFuture,
            builder: (context, snapshot) {
              String message;
              if (snapshot.error case final value?) {
                message = value.toString();
              } else if (snapshot.data case final value?) {
                message = 'Compressed size: ${value.length}, Raw size: ${data.length}';
              } else {
                message = 'In progress...';
              }

              return Text(message);
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _brotliFuture = CatalystCompression.instance.brotli.compress(data);
  }
}
