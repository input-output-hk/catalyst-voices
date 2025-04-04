import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/widgets.dart';

class CountDownValueCard extends StatelessWidget {
  final int value;
  final String unit;

  const CountDownValueCard({
    super.key,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 167,
      width: 144,
      decoration: BoxDecoration(
        color: context.colors.onSurfaceSecondary08,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              height: 1,
              color: context.colorScheme.primary,
            ),
          ),
          Text(
            unit.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
              height: 1,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
