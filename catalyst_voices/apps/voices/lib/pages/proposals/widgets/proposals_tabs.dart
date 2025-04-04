import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalsTabs extends StatelessWidget {
  const ProposalsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, ProposalsTypeCount>(
      selector: (state) => state.count,
      builder: (context, state) => _ProposalsTabs(data: state),
    );
  }
}

class _ProposalsTabs extends StatelessWidget {
  final ProposalsTypeCount data;

  const _ProposalsTabs({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerHeight: 0,
      tabs: [
        Tab(
          key: const Key('AllProposalsTab'),
          text: context.l10n.noOfAll(data.total),
        ),
        Tab(
          key: const Key('DraftProposalsTab'),
          text: context.l10n.noOfDraft(data.drafts),
        ),
        Tab(
          key: const Key('FinalProposalsTab'),
          text: context.l10n.noOfFinal(data.finals),
        ),
        Tab(
          key: const Key('FavoriteProposalsTab'),
          text: context.l10n.noOfFavorites(data.favorites),
        ),
        Tab(
          key: const Key('MyProposalsTab'),
          text: context.l10n.noOfMyProposals(data.my),
        ),
      ],
    );
  }
}
