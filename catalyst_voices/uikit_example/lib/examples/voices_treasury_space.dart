import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesTreasurySpace extends StatelessWidget {
  static const String route = '/treasury-space';

  const VoicesTreasurySpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(
        backgroundColor: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
      ),
      drawer: const VoicesDrawer(children: []),
      body: SpaceContainer(),
    );
  }
}
