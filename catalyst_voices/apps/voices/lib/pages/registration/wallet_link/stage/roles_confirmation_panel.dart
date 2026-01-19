import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/account_role_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RolesConfirmationPanel extends StatelessWidget {
  const RolesConfirmationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          RegistrationStageMessage(
            title: Text(context.l10n.walletDrepLinkAddKeyTitle),
            subtitle: const SizedBox.shrink(),
            spacing: 12,
          ),
          const SizedBox(height: 12),
          const _BlocNewRolesSummaryContainer(),
        ],
      ),
      footer: VoicesFilledButton(
        leading: VoicesAssets.icons.wallet.buildIcon(),
        onTap: RegistrationCubit.of(context).nextStep,
        child: Text(context.l10n.selectWallet),
      ),
    );
  }
}

class _BlocNewRolesSummaryContainer extends StatelessWidget {
  const _BlocNewRolesSummaryContainer();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<List<RegistrationRole>>(
      selector: (state) => state.newlyAddedRoles,
      builder: (context, newRoles) => _RolesSummaryContainer(roles: newRoles),
    );
  }
}

class _RolesSummaryContainer extends StatelessWidget {
  final List<RegistrationRole> roles;

  const _RolesSummaryContainer({
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: roles.map<Widget>((role) {
        return RoleChooserCard(
          icon: role.type.icon.buildIcon(
            size: 66,
            allowColorFilter: false,
          ),
          value: role.isSelected,
          label: role.type.getName(context),
          isDefault: role.type.isDefault,
          displayValue: false,
          onLearnMore: () async {
            await AccountRoleDialog.show(
              context,
              role: role.type,
            );
          },
        );
      }).toList(),
    );
  }
}
