import 'package:flutter/material.dart';
import 'package:remote_widgets_example/src/remote_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Widgets Example'),
      ),
      body: const Center(
        child: RemoteForm(),
      ),
    );
  }
}
