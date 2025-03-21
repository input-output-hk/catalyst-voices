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
      sm: 16,
      md: 32,
      other: 56,
      builder: (context, spacing) {
        return SidebarScaffold(
          leftRail: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: navPanel,
          ),
          bodyConstraints: const BoxConstraints.expand(),
          spacing: 0,
          body: Padding(
            padding: EdgeInsets.only(right: spacing),
            child: body,
          ),
        );
      },
    );
  }
}
