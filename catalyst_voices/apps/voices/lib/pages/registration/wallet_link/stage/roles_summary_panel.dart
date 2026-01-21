import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RolesSummaryPanel extends StatelessWidget {
  const RolesSummaryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          RegistrationStageMessage(
            title: Text(context.l10n.walletLinkRoleSummaryTitle),
            subtitle: const _BlocSubtitle(),
            spacing: 12,
          ),
          const SizedBox(height: 12),
          const _BlocRolesSummaryContainer(),
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VoicesFilledButton(
            leading: VoicesAssets.icons.wallet.buildIcon(),
            onTap: () {
              RegistrationCubit.of(context).nextStep();
            },
            child: Text(
              context.l10n.reviewRegistrationTransaction,
              semanticsIdentifier: 'RolesSummaryReviewTransaction',
            ),
          ),
          const SizedBox(height: 10),
          VoicesTextButton(
            onTap: () {
              RegistrationCubit.of(context).changeRoleSetup();
            },
            child: Text(
              context.l10n.walletLinkTransactionChangeRoles,
              semanticsIdentifier: 'RolesSummaryChangeRoles',
            ),
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
    return BlocWalletLinkSelector<IterableData<List<RegistrationRole>>>(
      selector: (state) => state.rolesData,
      builder: (context, data) => RolesSummaryContainer(roles: data.value),
    );
  }
}

class _BlocSubtitle extends StatelessWidget {
  const _BlocSubtitle();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<IterableData<Set<AccountRole>>>(
      selector: (state) => state.selectedRoleTypesData,
      builder: (context, data) {
        return _Subtitle(selectedRoles: data.value);
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
          TextSpan(text: context.l10n.walletLinkRoleSummaryContent1),
          TextSpan(
            text: context.l10n.walletLinkRoleSummaryContent2(selectedRoles.length),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: context.l10n.walletLinkRoleSummaryContent3),
        ],
      ),
    );
  }
}
