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
  const RolesSummaryPanel({
    super.key,
  });

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
            child: Text(context.l10n.reviewRegistrationTransaction),
          ),
          const SizedBox(height: 10),
          VoicesTextButton(
            onTap: () {
              RegistrationCubit.of(context).changeRoleSetup();
            },
            child: Text(context.l10n.walletLinkTransactionChangeRoles),
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
    return BlocWalletLinkSelector<List<RegistrationRole>>(
      selector: (state) => state.roles,
      builder: (context, state) => RolesSummaryContainer(roles: state),
    );
  }
}

class _BlocSubtitle extends StatelessWidget {
  const _BlocSubtitle();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<Set<AccountRole>>(
      selector: (state) => state.selectedRoleTypes,
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
            text: context.l10n.walletLinkRoleSummaryContent2(selectedRoles.length),
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
