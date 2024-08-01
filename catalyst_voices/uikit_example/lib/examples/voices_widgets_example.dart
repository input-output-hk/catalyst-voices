import 'package:flutter/material.dart';
import 'package:uikit_example/examples/widgets/segmented_button_examples.dart';

class VoicesWidgetsExample extends StatelessWidget {
  static const String route = '/widgets-example';

  const VoicesWidgetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widgets')),
      body: const SizedBox.expand(
        child: _ExampleSectionsBody(
          children: [
            _WidgetsSection(
              key: ValueKey('SegmentedButton'),
              name: 'SegmentedButton',
              child: SegmentedButtonExamples(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleSectionsBody extends StatelessWidget {
  final List<Widget> children;

  const _ExampleSectionsBody({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _WidgetsSection extends StatelessWidget {
  final String name;
  final Widget child;

  const _WidgetsSection({
    required super.key,
    required this.name,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }
}
