import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:flutter/material.dart';

class VoicesTreasurySpace extends StatelessWidget {
  static const String route = '/treasury-space';

  const VoicesTreasurySpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(),
    );
  }
}
