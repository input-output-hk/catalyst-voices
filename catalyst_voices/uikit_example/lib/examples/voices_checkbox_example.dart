import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesCheckboxExample extends StatefulWidget {
  static const String route = '/checkbox-example';

  const VoicesCheckboxExample({super.key});

  @override
  State<VoicesCheckboxExample> createState() => _VoicesCheckboxExampleState();
}

class _VoicesCheckboxExampleState extends State<VoicesCheckboxExample> {
  final _checkboxesStates = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Checkbox')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          VoicesCheckbox(
            value: _checkboxesStates[0] ?? false,
            onChanged: (value) {
              setState(() {
                _checkboxesStates[0] = value;
              });
            },
          ),
          const SizedBox(height: 8),
          const VoicesCheckbox(
            value: false,
            onChanged: null,
          ),
          const SizedBox(height: 8),
          VoicesCheckbox(
            value: _checkboxesStates[2] ?? false,
            onChanged: (value) {
              setState(() {
                _checkboxesStates[2] = value;
              });
            },
            isError: true,
          ),
          const SizedBox(height: 8),
          VoicesCheckbox(
            value: _checkboxesStates[3] ?? false,
            onChanged: (value) {
              setState(() {
                _checkboxesStates[3] = value;
              });
            },
            label: const Text('Label'),
            note: const Text('Note'),
          ),
          const SizedBox(height: 8),
          VoicesCheckbox(
            value: _checkboxesStates[4] ?? false,
            onChanged: (value) {
              setState(() {
                _checkboxesStates[4] = value;
              });
            },
            isError: true,
            label: const Text('Error label'),
          ),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).colorScheme.onSurface),
            ),
            child: VoicesCheckboxGroup(),
          ),
        ],
      ),
    );
  }
}
