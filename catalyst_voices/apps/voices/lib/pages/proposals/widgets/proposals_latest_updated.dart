import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalsLatestUpdated extends StatelessWidget {
  const ProposalsLatestUpdated({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, ProposalsStateLatestUpdateCheckbox>(
      selector: (state) => state.latestUpdatedCheckbox,
      builder: (context, state) {
        return _ProposalsLatestUpdated(
          maxAge: state.maxAge,
          isEnabled: state.isEnabled,
        );
      },
    );
  }
}

class _ProposalsLatestUpdated extends StatelessWidget {
  final Duration maxAge;
  final bool isEnabled;

  const _ProposalsLatestUpdated({
    required this.maxAge,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<ProposalsCubit>()
            .changeFilters(isRecentEnabled: !isEnabled, resetProposals: true);
      },
      child: AffixDecorator(
        suffix: Text(
          context.l10n.proposalsLatestUpdatesHours(maxAge.inHours),
          style: context.textTheme.bodyLarge?.copyWith(color: context.colors.textOnPrimaryLevel0),
        ),
        child: VoicesCheckbox(
          value: isEnabled,
          onChanged: (value) {
            context
                .read<ProposalsCubit>()
                .changeFilters(isRecentEnabled: value, resetProposals: true);
          },
        ),
      ),
    );
  }
}
