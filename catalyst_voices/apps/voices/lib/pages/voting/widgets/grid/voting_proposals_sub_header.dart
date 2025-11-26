import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VotingProposalsSubHeader extends StatelessWidget {
  const VotingProposalsSubHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, bool>(
      selector: (state) => state.hasSelectedCategory,
      builder: (context, hasCategory) {
        return Text(
          hasCategory ? context.l10n.categoryProposals : context.l10n.proposals,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colors.textOnPrimaryLevel0,
          ),
        );
      },
    );
  }
}
