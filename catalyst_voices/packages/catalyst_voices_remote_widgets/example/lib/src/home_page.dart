// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:remote_widgets_example/src/remote_form.dart';
import 'package:remote_widgets_example/src/widgets/local_widget.dart';
import 'package:remote_widgets_example/src/widgets/new_local_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showLocalWidget = true;

  String get _title => _showLocalWidget ? 'Local Widgets' : 'Remote Widgets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Widgets Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _title,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 160, 17, 227),
              ),
            ),
            const SizedBox(height: 80),
            _showLocalWidget ? const LocalWidget() : const RemoteForm(),
          ],
        ),
        // child: NewLocalWidgets(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _toggleShownWidget(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _toggleShownWidget() {
    setState(() {
      _showLocalWidget = !_showLocalWidget;
    });
  }
}
