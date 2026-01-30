import 'dart:async';

import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_card_widgets.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_delegated_to_card.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_learn_more_dialog.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_representative_total_power_card.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_representing_card.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_popup_menu.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountVotingRoleCard extends StatelessWidget {
  const AccountVotingRoleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingRoleViewModel>(
      selector: (state) => state.votingRole,
      builder: (context, votingRole) => _AccountVotingRoleCards(votingRole: votingRole),
    );
  }
}

class _AccountVotingRoleCards extends StatelessWidget {
  final VotingRoleViewModel votingRole;

  const _AccountVotingRoleCards({
    required this.votingRole,
  });

  @override
  Widget build(BuildContext context) {
    return switch (votingRole) {
      VotingRoleViewModelDelegator(
        :final votingPower,
        :final representativesCount,
      ) =>
        _DelegatorVotingRoleCards(
          votingPower: votingPower,
          representativesCount: representativesCount,
        ),
      VotingRoleViewModelIndividual(:final votingPower) => _IndividualVotingRoleCards(
        votingPower: votingPower,
      ),
      VotingRoleViewModelRepresentative(
        :final totalVotingPower,
        :final ownVotingPower,
        :final delegatedVotingPower,
        :final delegatorsCount,
      ) =>
        _RepresentativeVotingRoleCards(
          totalVotingPower: totalVotingPower,
          ownVotingPower: ownVotingPower,
          delegatedVotingPower: delegatedVotingPower,
          delegatorsCount: delegatorsCount,
        ),
      EmptyVotingRoleViewModel() => const Offstage(),
    };
  }
}

class _DelegatorVotingRoleCards extends StatelessWidget {
  final VotingPowerViewModel votingPower;
  final int representativesCount;

  const _DelegatorVotingRoleCards({
    required this.votingPower,
    required this.representativesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        AccountVotingRoleDelegatedToCard(
          votingPower: votingPower,
          representativesCount: representativesCount,
        ),
        AccountVotingRoleInfoCard(
          label: Text(context.l10n.myDelegatedVotingPower),
          value: Text(votingPower.amount.formattedWithSymbol),
          infoButton: AccountVotingRoleInfoButton(
            onTap: () {
              unawaited(
                AccountVotingRoleLearnMoreDialog.show(
                  context: context,
                  title: context.l10n.votingRoleMyDelegatedPowerLearnMoreDialogTitle,
                  message: context.l10n.votingRoleMyDelegatedPowerLearnMoreDialogMessage,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _IndividualVotingRoleCards extends StatelessWidget {
  final VotingPowerViewModel votingPower;

  const _IndividualVotingRoleCards({required this.votingPower});

  @override
  Widget build(BuildContext context) {
    return AccountVotingRoleInfoCard(
      label: Text(context.l10n.myVotingPower),
      value: Text(votingPower.amount.formattedWithSymbol),
      infoButton: AccountVotingRolePopupInfoButton(
        menuBuilder: (context) => AccountVotingRolePopupMenu(
          title: context.l10n.votingPower,
          message: context.l10n.votingRoleIndividualPopupMessage,
          updatedAt: votingPower.updatedAt,
          status: votingPower.status,
          onLearnMore: () {
            unawaited(
              AccountVotingRoleLearnMoreDialog.show(
                context: context,
                title: context.l10n.votingRoleIndividualLearnMoreDialogTitle,
                message: context.l10n.votingRoleIndividualLearnMoreDialogMessage,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RepresentativeVotingRoleCards extends StatelessWidget {
  final VotingPowerViewModel totalVotingPower;
  final VotingPowerViewModel ownVotingPower;
  final VotingPowerViewModel delegatedVotingPower;
  final int delegatorsCount;

  const _RepresentativeVotingRoleCards({
    required this.totalVotingPower,
    required this.ownVotingPower,
    required this.delegatedVotingPower,
    required this.delegatorsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        AccountVotingRoleRepresentativeTotalPowerCard(
          totalVotingPower: totalVotingPower,
          ownVotingPower: ownVotingPower,
          delegatedVotingPower: delegatedVotingPower,
        ),
        AccountVotingRoleRepresentingCard(
          delegatorsCount: delegatorsCount,
        ),
      ],
    );
  }
}
