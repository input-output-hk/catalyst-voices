import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesSwitchExample extends StatefulWidget {
  static const String route = '/switch-example';

  const VoicesSwitchExample({
    super.key,
  });

  @override
  State<VoicesSwitchExample> createState() => _VoicesSwitchExampleState();
}

class _VoicesSwitchExampleState extends State<VoicesSwitchExample> {
  final _switchStateMap = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Switch')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            VoicesSwitch(
              value: _switchStateMap[0] ?? true,
              onChanged: (value) {
                setState(() {
                  _switchStateMap[0] = value;
                });
              },
            ),
            const SizedBox(height: 8),
            VoicesSwitch(
              value: _switchStateMap[1] ?? true,
              thumbIcon: Icons.check,
              onChanged: (value) {
                setState(() {
                  _switchStateMap[1] = value;
                });
              },
            ),
            const SizedBox(height: 8),
            const VoicesSwitch(value: false),
            const SizedBox(height: 8),
            const VoicesSwitch(
              value: false,
              thumbIcon: Icons.close,
            ),
          ],
        ),
      ),
    );
  }
}
