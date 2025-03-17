import 'package:flutter/material.dart';

class GreyOutContainer extends StatelessWidget {
  final bool greyOut;
  final double greyOutOpacity;
  final Widget child;

  const GreyOutContainer({
    super.key,
    this.greyOut = true,
    this.greyOutOpacity = 0.5,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: greyOut,
      child: Opacity(
        opacity: greyOut ? greyOutOpacity : 1,
        child: child,
      ),
    );
  }
}
