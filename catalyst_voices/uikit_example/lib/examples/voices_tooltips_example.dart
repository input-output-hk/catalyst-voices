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
              message: 'This is very long supporting text. '
                  'This is very long supporting text. '
                  'This is very long supporting text. '
                  'This is very long supporting text.',
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
          Center(
            child: VoicesRichTooltip(
              title: 'Title',
              message: 'This is supporting text. This is supporting text.',
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Rich Tooltip trigger',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Center(
            child: VoicesRichTooltip(
              title: 'Title',
              message: 'This is supporting text. This is supporting text.',
              actions: [
                VoicesRichTooltipActionData(
                  name: 'Action',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tooltip action clicked!')),
                    );
                  },
                ),
                VoicesRichTooltipActionData(
                  name: 'Action',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tooltip action clicked!')),
                    );
                  },
                ),
              ],
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Rich Tooltip [Actions] trigger',
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
