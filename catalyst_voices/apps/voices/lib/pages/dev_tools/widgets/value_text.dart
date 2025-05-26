import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class ValueText extends StatelessWidget {
  final Widget name;
  final Widget? value;

  const ValueText({
    super.key,
    required this.name,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: context.textTheme.bodyMedium ?? const TextStyle(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          name,
          const Text(': '),
          Flexible(
            child: SelectionArea(
              child: DefaultTextStyle.merge(
                style: const TextStyle(fontWeight: FontWeight.bold),
                child: value ?? const Text('-'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
