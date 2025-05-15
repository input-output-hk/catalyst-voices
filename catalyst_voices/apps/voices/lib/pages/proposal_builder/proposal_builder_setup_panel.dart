import 'dart:async';

import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_guidance.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalBuilderSetupPanel extends StatefulWidget {
  const ProposalBuilderSetupPanel({super.key});

  @override
  State<ProposalBuilderSetupPanel> createState() => _ProposalBuilderSetupPanelState();
}

class _ProposalBuilderSetupPanelState extends State<ProposalBuilderSetupPanel> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<dynamic>? _guidanceSub;

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      scrollController: _scrollController,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: context.l10n.guidance,
          body: const ProposalBuilderGuidanceSelector(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    unawaited(_guidanceSub?.cancel());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProposalBuilderBloc>();

    _guidanceSub = bloc.stream
        .map((state) => state.guidance)
        .distinct()
        .listen((_) => _scrollController.jumpTo(0));
  }
}
