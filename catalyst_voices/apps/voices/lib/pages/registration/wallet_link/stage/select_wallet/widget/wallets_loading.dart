import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WalletsLoading extends StatelessWidget {
  const WalletsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: VoicesCircularProgressIndicator(),
    );
  }
}
