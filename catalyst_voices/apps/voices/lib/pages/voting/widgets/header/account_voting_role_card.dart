import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountVotingRoleCardSelector extends StatelessWidget {
  const AccountVotingRoleCardSelector({super.key});

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
      VotingRoleViewModelDelegator(:final votingPower, :final representativesCount) =>
        _DelegatorVotingRoleCards(
          votingPower: votingPower,
          representativesCount: representativesCount,
        ),
      VotingRoleViewModelIndividual(:final votingPower) => _IndividualVotingRoleCards(
        votingPower: votingPower,
      ),
      VotingRoleViewModelRepresentative(
        :final ownVotingPower,
        :final delegatedVotingPower,
        :final delegatorsCount,
      ) =>
        _RepresentativeVotingRoleCards(
          ownVotingPower: ownVotingPower,
          delegatedVotingPower: delegatedVotingPower,
          delegatorsCount: delegatorsCount,
        ),
      NullVotingRoleViewModel() => const Offstage(),
    };
  }
}

class _CardDecoration extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final Widget child;

  const _CardDecoration({
    this.padding,
    this.color,
    this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: color,
        gradient: gradient,
      ),
      child: child,
    );
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
    return _InfoCard(
      label: context.l10n.myDelegatedVotingPower,
      value: votingPower.amount,
      onInfoTap: () {
        // TODO(dt-iohk): https://github.com/input-output-hk/catalyst-voices/issues/3968
      },
    );
  }
}

class _IndividualVotingRoleCards extends StatelessWidget {
  final VotingPowerViewModel votingPower;

  const _IndividualVotingRoleCards({required this.votingPower});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      label: context.l10n.myVotingPower,
      value: votingPower.amount,
      onInfoTap: () {
        // TODO(dt-iohk): https://github.com/input-output-hk/catalyst-voices/issues/3968
      },
    );
  }
}

class _InfoButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onTap;

  const _InfoButton({
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: VoicesAssets.icons.informationCircle.buildIcon(
        color: color ?? Theme.of(context).colors.iconsPrimary,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onInfoTap;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _CardDecoration(
      padding: const EdgeInsets.fromLTRB(24, 12, 8, 18),
      color: theme.colors.elevationsOnSurfaceNeutralLv1White,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colors.textOnPrimaryLevel0,
                ),
              ),
              _InfoButton(onTap: onInfoTap),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepresentativeVotingRoleCards extends StatelessWidget {
  final VotingPowerViewModel ownVotingPower;
  final VotingPowerViewModel delegatedVotingPower;
  final int delegatorsCount;

  const _RepresentativeVotingRoleCards({
    required this.ownVotingPower,
    required this.delegatedVotingPower,
    required this.delegatorsCount,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
