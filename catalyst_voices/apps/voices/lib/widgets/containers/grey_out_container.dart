import 'package:flutter/material.dart';

class GreyOutContainer extends StatelessWidget {
  final bool greyOut;
  final Widget child;

  const GreyOutContainer({
    super.key,
    this.greyOut = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: greyOut,
      child: Opacity(
        opacity: greyOut ? 0.5 : 1,
        child: child,
      ),
    );
  }
}
