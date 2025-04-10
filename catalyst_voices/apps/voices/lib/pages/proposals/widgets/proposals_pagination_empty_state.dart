import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalsPaginationEmptyState extends StatelessWidget {
  const ProposalsPaginationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, bool>(
      selector: (state) => state.hasSearchQuery,
      builder: (context, state) {
        return _ProposalsPaginationEmptyState(hasSearchQuery: state);
      },
    );
  }
}

class _ProposalsPaginationEmptyState extends StatelessWidget {
  final bool hasSearchQuery;

  const _ProposalsPaginationEmptyState({
    required this.hasSearchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasSearchQuery)
          Text(
            context.l10n.searchResult,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        EmptyState(
          key: const Key('EmptyProposals'),
          title: hasSearchQuery ? context.l10n.emptySearchResultTitle : null,
          description: hasSearchQuery
              ? context.l10n.tryDifferentSearch
              : context.l10n.discoverySpaceEmptyProposals,
        ),
      ],
    );
  }
}
