import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalSidebars extends StatelessWidget {
  final Widget navPanel;
  final Widget body;

  const ProposalSidebars({
    super.key,
    required this.navPanel,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<double>(
      xs: 0,
      sm: 16,
      md: 32,
      lg: 56,
      builder: (context, spacing) {
        return SidebarScaffold(
          // TODO(LynxLynxx): Remove when we support mobile web
          leftRail: ResponsiveBuilder<bool>(
            sm: true,
            md: false,
            builder: (context, isSmallScreen) => Offstage(
              offstage: isSmallScreen,
              child: Padding(
                padding: EdgeInsets.only(left: spacing / 2, right: spacing / 2, top: 40),
                child: navPanel,
              ),
            ),
          ),
          spacing: 0,
          body: Padding(
            padding: EdgeInsets.only(right: spacing),
            child: body,
          ),
          bodyConstraints: const BoxConstraints.expand(),
        );
      },
    );
  }
}
