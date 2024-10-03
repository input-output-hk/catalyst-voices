import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolesSummaryPanel extends StatelessWidget {
  const RolesSummaryPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: Text(context.l10n.walletLinkRoleSummaryTitle),
          subtitle: const _BlocSubtitle(),
          spacing: 12,
        ),
        const SizedBox(height: 12),
        const _BlocRolesSummaryContainer(),
        const Spacer(),
        VoicesFilledButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: () {
            RegistrationCubit.of(context).nextStep();
          },
          child: Text(context.l10n.walletLinkRoleSummaryButton),
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          onTap: () {
            RegistrationCubit.of(context).changeRoleSetup();
          },
          child: Text(context.l10n.walletLinkTransactionChangeRoles),
        ),
      ],
    );
  }
}

class _BlocSubtitle extends StatelessWidget {
  const _BlocSubtitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final selectedRoles = state.walletLinkStateData.selectedRoles ??
            state.walletLinkStateData.defaultRoles;

        return _Subtitle(selectedRoles: selectedRoles);
      },
    );
  }
}

class _Subtitle extends StatelessWidget {
  final Set<AccountRole> selectedRoles;

  const _Subtitle({required this.selectedRoles});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: context.l10n.walletLinkRoleSummaryContent1,
          ),
          TextSpan(
            text: context.l10n
                .walletLinkRoleSummaryContent2(selectedRoles.length),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: context.l10n.walletLinkRoleSummaryContent3,
          ),
        ],
      ),
    );
  }
}

class _BlocRolesSummaryContainer extends StatelessWidget {
  const _BlocRolesSummaryContainer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      buildWhen: (previous, current) {
        final areDefaultRolesSame = setEquals(
          previous.walletLinkStateData.defaultRoles,
          current.walletLinkStateData.defaultRoles,
        );

        final areSelectedRolesSame = setEquals(
          previous.walletLinkStateData.selectedRoles,
          current.walletLinkStateData.selectedRoles,
        );

        return !areDefaultRolesSame || !areSelectedRolesSame;
      },
      builder: (context, state) {
        final defaultRoles = state.walletLinkStateData.defaultRoles;
        final selectedRoles = state.walletLinkStateData.selectedRoles;

        return RolesSummaryContainer(
          selected: selectedRoles ?? defaultRoles,
          lockedValuesAsDefault: defaultRoles,
        );
      },
    );
  }
}
