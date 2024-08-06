import 'package:catalyst_voices/widgets/toggles/voices_checkbox.dart';
import 'package:flutter/material.dart';

class VoicesCheckboxExample extends StatefulWidget {
  static const String route = '/checkbox-example';

  const VoicesCheckboxExample({super.key});

  @override
  State<VoicesCheckboxExample> createState() => _VoicesCheckboxExampleState();
}

class _VoicesCheckboxExampleState extends State<VoicesCheckboxExample> {
  bool _first = false;
  final bool _second = false;
  bool _third = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Checkbox')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          VoicesCheckbox(
            value: _first,
            onChanged: (value) {
              setState(() {
                _first = value;
              });
            },
          ),
          const SizedBox(height: 8),
          VoicesCheckbox(
            value: _second,
            onChanged: null,
          ),
          const SizedBox(height: 8),
          VoicesCheckbox(
            value: _third,
            onChanged: (value) {
              setState(() {
                _third = value;
              });
            },
            isError: true,
          ),
        ],
      ),
    );
  }
}
