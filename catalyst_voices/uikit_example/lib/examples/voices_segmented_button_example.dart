import 'package:catalyst_voices/widgets/buttons/voices_segmented_button.dart';
import 'package:flutter/material.dart';

enum _Size { xs, s, m, l, xl, xxl }

class VoicesSegmentedButtonExample extends StatefulWidget {
  static const String route = '/segmented-button-example';

  const VoicesSegmentedButtonExample({super.key});

  @override
  State<VoicesSegmentedButtonExample> createState() {
    return _VoicesSegmentedButtonExampleState();
  }
}

class _VoicesSegmentedButtonExampleState
    extends State<VoicesSegmentedButtonExample> {
  Set<_Size> _labelsSelection = const {_Size.m};
  Set<_Size> _emptySelection = const {};
  Set<_Size> _iconsMultiSelection = const {_Size.m};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VoicesSegmentedButton')),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Labels single select'),
                VoicesSegmentedButton<_Size>(
                  segments: _buildSegments(
                    showLabel: true,
                    disabled: {_Size.xxl},
                  ),
                  selected: _labelsSelection,
                  onChanged: (selected) {
                    setState(() {
                      _labelsSelection = Set.from(selected);
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Icons single select, allow empty'),
                VoicesSegmentedButton<_Size>(
                  segments: _buildSegments(showLabel: true),
                  selected: _emptySelection,
                  onChanged: (selected) {
                    setState(() {
                      _emptySelection = Set.from(selected);
                    });
                  },
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                ),
                const SizedBox(height: 16),
                const Text('Icons multi select, allow empty'),
                VoicesSegmentedButton<_Size>(
                  segments: _buildSegments(showIcon: true),
                  selected: _iconsMultiSelection,
                  onChanged: (selected) {
                    setState(() {
                      _iconsMultiSelection = Set.from(selected);
                    });
                  },
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                  multiSelectionEnabled: true,
                ),
                const SizedBox(height: 16),
                const Text('Icons multi select, disabled'),
                VoicesSegmentedButton<_Size>(
                  segments: _buildSegments(
                    showLabel: true,
                    showIcon: true,
                  ),
                  selected: const {},
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<ButtonSegment<_Size>> _buildSegments({
    bool showLabel = false,
    bool showIcon = false,
    Set<_Size> disabled = const {},
  }) {
    return _Size.values.map(
      (size) {
        return ButtonSegment(
          value: size,
          label: showLabel ? Text(size.name.toUpperCase()) : null,
          icon: showIcon ? const Icon(Icons.add) : null,
          enabled: !disabled.contains(size),
        );
      },
    ).toList();
  }
}
