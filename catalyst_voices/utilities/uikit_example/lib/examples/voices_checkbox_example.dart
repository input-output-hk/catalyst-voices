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
  final _checkboxGroupSelection = <int>{};

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
          const SizedBox(height: 16),
          const VoicesCheckbox(
            value: false,
            onChanged: null,
          ),
          const SizedBox(height: 16),
          VoicesCheckbox(
            value: _checkboxesStates[2] ?? false,
            onChanged: (value) {
              setState(() {
                _checkboxesStates[2] = value;
              });
            },
            isError: true,
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          VoicesCheckboxGroup(
            name: const Text('Select all'),
            elements: const [
              VoicesCheckboxGroupElement(
                value: 1,
                label: Text('Founded'),
              ),
              VoicesCheckboxGroupElement(
                value: 2,
                label: Text('Not founded'),
              ),
              VoicesCheckboxGroupElement(
                value: 3,
                label: Text('Not founded'),
              ),
              VoicesCheckboxGroupElement(
                value: 4,
                label: Text('In progress'),
              ),
              VoicesCheckboxGroupElement(
                value: 5,
                label: Text('Not founded'),
                note: Text('Danger'),
                isError: true,
              ),
            ],
            selected: _checkboxGroupSelection,
            onChanged: (value) {
              setState(() {
                _checkboxGroupSelection
                  ..clear()
                  ..addAll(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
