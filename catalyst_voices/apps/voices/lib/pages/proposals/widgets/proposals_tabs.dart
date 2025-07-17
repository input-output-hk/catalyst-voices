import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsTabs extends StatelessWidget {
  final TabController controller;

  const ProposalsTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, ProposalsCount>(
      selector: (state) => state.count,
      builder: (context, state) {
        return _ProposalsTabs(
          data: state,
          controller: controller,
        );
      },
    );
  }
}

class _ProposalsTabs extends StatelessWidget {
  final ProposalsCount data;
  final TabController controller;

  const _ProposalsTabs({
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isProposerUnlock =
        context.select<SessionCubit, bool>((cubit) => cubit.state.isProposerUnlock);

    return VoicesTabBar(
      dividerHeight: 0,
      controller: controller,
      onTap: (tab) {
        final type = tab.data;
        context.read<ProposalsCubit>().emitSignal(ChangeFilterTypeProposalsSignal(type));
      },
      tabs: [
        for (final type in ProposalsFilterType.values)
          VoicesTab(
            data: type,
            key: type.tabKey(),
            isOffstage: !isProposerUnlock && type.isMy,
            child: VoicesTabText(type.noOf(context, count: _getCount(type))),
          ),
      ],
    );
  }

  int _getCount(ProposalsFilterType type) {
    return switch (type) {
      ProposalsFilterType.total => data.total,
      ProposalsFilterType.drafts => data.drafts,
      ProposalsFilterType.finals => data.finals,
      ProposalsFilterType.favorites => data.favorites,
      ProposalsFilterType.my => data.my,
    };
  }
}
