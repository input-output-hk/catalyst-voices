import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesShellPage extends StatelessWidget {
  final Space space;
  final Widget child;

  const SpacesShellPage({
    super.key,
    required this.space,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(),
      drawer: Builder(
        builder: (context) {
          return VoicesDrawer(
            children: [],
            bottom: VoicesDrawerSpaceChooser(
              currentSpace: space,
              onChanged: (space) {
                Scaffold.of(context).closeDrawer();

                switch (space) {
                  case Space.treasury:
                    TreasuryRoute().go(context);
                  case Space.discovery:
                    DiscoveryRoute().go(context);
                  case Space.workspace:
                    TreasuryRoute().go(context);
                  case Space.voting:
                    TreasuryRoute().go(context);
                }
              },
            ),
          );
        },
      ),
      body: child,
    );
  }
}
