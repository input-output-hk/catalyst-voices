import 'package:catalyst_voices/pages/registration/wallet_link/account_role_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/containers/roles_chooser_container.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RolesChooserPanel extends StatelessWidget {
  const RolesChooserPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          RegistrationStageMessage(
            title: Text(context.l10n.walletLinkRoleChooserTitle),
            subtitle: Text(context.l10n.walletLinkRoleChooserContent),
            spacing: 12,
          ),
          const SizedBox(height: 12),
          const _BlocRolesChooserContainer(),
        ],
      ),
      footer: const _Navigation(),
    );
  }
}

class _BlocRolesChooserContainer extends StatelessWidget {
  const _BlocRolesChooserContainer();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<IterableData<List<RegistrationRole>>>(
      selector: (state) => state.rolesData,
      builder: (context, data) {
        return RolesChooserContainer(
          roles: data.value,
          onChanged: RegistrationCubit.of(context).walletLink.selectRoles,
          onLearnMore: (role) async {
            await AccountRoleDialog.show(
              context,
              role: role,
            );
          },
        );
      },
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<bool>(
      selector: (state) => state.areRolesValid,
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled: state,
        );
      },
    );
  }
}
