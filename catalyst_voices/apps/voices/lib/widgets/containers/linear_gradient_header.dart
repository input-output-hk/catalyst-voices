import 'package:flutter/material.dart';

class LinearGradientHeader extends StatelessWidget {
  const LinearGradientHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x33BB8DEF),
            Color(0x6695C6FF),
            Color(0x00DBE2F0),
          ],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
          stops: [0.015, 0.5, 1.0],
        ),
      ),
    );
  }
}
