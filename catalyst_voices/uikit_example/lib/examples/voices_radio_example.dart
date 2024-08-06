import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesRadioExample extends StatefulWidget {
  static const String route = '/radio-example';

  const VoicesRadioExample({super.key});

  @override
  State<VoicesRadioExample> createState() => _VoicesRadioExampleState();
}

class _VoicesRadioExampleState extends State<VoicesRadioExample> {
  int? _current = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Radio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VoicesRadio<int>(
              value: 0,
              groupValue: _current,
              onChanged: _updateGroupSelection,
            ),
            const SizedBox(height: 8),
            VoicesRadio<int>(
              value: 1,
              groupValue: _current,
              onChanged: _updateGroupSelection,
            ),
            const SizedBox(height: 8),
            VoicesRadio<int>(
              value: 2,
              groupValue: _current,
              onChanged: null,
            ),
          ],
        ),
      ),
    );
  }

  void _updateGroupSelection(int? value) {
    setState(() {
      _current = value;
    });
  }
}
