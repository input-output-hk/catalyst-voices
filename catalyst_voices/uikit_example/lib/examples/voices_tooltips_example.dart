import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesTooltipsExample extends StatelessWidget {
  static const String route = '/tooltips-example';

  const VoicesTooltipsExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tooltips')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        children: <Widget>[
          Center(
            child: VoicesPlainTooltip(
              message: 'Supporting text',
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Plain Tooltip trigger',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Center(
            child: VoicesPlainTooltip(
              message: 'Supporting text Body text string goes here psum dolor '
                  'sit amet, consectetur adipiscing elit, sed do eiusmod '
                  'tempor incididunt',
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Big Plain Tooltip trigger',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ].separatedBy(const SizedBox(height: 16)).toList(),
      ),
    );
  }
}
