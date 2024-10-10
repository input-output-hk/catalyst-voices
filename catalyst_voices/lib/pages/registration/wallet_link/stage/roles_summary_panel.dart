import 'package:catalyst_voices/pages/registration/wallet_link/bloc_wallet_link_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

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
    return BlocWalletLinkBuilder<Set<AccountRole>>(
      selector: (state) => state.selectedRoles ?? state.defaultRoles,
      builder: (context, state) {
        return _Subtitle(selectedRoles: state);
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
    return BlocWalletLinkBuilder<
        ({
          Set<AccountRole> selected,
          Set<AccountRole> defaultRoles,
        })>(
      selector: (state) => (
        selected: state.selectedRoles ?? state.defaultRoles,
        defaultRoles: state.defaultRoles,
      ),
      builder: (context, state) {
        return RolesSummaryContainer(
          selected: state.selected,
          lockedValuesAsDefault: state.defaultRoles,
        );
      },
    );
  }
}
