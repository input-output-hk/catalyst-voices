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
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerHeight: 0,
      controller: controller,
      onTap: (index) {
        final type = ProposalsFilterType.values[index];
        context.read<ProposalsCubit>().emitSignal(ChangeFilterTypeSignal(type));
      },
      tabs: ProposalsFilterType.values.map(
        (value) {
          final count = switch (value) {
            ProposalsFilterType.total => data.total,
            ProposalsFilterType.drafts => data.drafts,
            ProposalsFilterType.finals => data.finals,
            ProposalsFilterType.favorites => data.favorites,
            ProposalsFilterType.my => data.my,
          };

          return Tab(
            key: value.tabKey(),
            text: value.noOf(context, count: count),
          );
        },
      ).toList(),
    );
  }
}
