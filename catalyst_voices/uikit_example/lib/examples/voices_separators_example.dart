import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesSeparatorsExample extends StatelessWidget {
  static const String route = '/separators-example';

  const VoicesSeparatorsExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Switch')),
      body: Column(
        children: [
          ColoredBox(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Paragraph'),
            ),
          ),
          const VoicesDivider(),
          ColoredBox(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Paragraph'),
            ),
          ),
          const VoicesTextDivider(
            child: Text('Your account creation progress'),
          ),
          ColoredBox(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Paragraph'),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints.tight(const Size.square(48)),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                const VoicesVerticalDivider(),
                Container(
                  constraints: BoxConstraints.tight(const Size.square(48)),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                const VoicesVerticalDivider(),
                Container(
                  constraints: BoxConstraints.tight(const Size.square(48)),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
