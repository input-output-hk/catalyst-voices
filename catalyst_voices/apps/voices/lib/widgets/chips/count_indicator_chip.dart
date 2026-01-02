import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:flutter/material.dart';

class CountIndicatorChip extends StatelessWidget {
  final int count;

  const CountIndicatorChip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return VoicesChip.round(
      backgroundColor: context.colorScheme.error,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      content: Text(
        count.toString(),
        style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onError),
      ),
    );
  }
}
