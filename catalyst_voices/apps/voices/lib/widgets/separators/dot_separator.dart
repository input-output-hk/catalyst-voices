import 'package:flutter/material.dart';

class DotSeparator extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const DotSeparator({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: const Text(
        '·',
        textAlign: TextAlign.center,
      ),
    );
  }
}
