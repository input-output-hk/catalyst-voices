import 'package:catalyst_voices/pages/registration/wallet_link/account_role_dialog.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/bloc_wallet_link_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/containers/roles_chooser_container.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class RolesChooserPanel extends StatelessWidget {
  const RolesChooserPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: Text(context.l10n.walletLinkRoleChooserTitle),
          subtitle: Text(context.l10n.walletLinkRoleChooserContent),
          spacing: 12,
        ),
        const SizedBox(height: 12),
        const _BlocRolesChooserContainer(),
        const Spacer(),
        const RegistrationBackNextNavigation(),
        const SizedBox(height: 10),
        VoicesTextButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: () {
            RegistrationCubit.of(context).chooseOtherWallet();
          },
          child: Text(context.l10n.chooseOtherWallet),
        ),
      ],
    );
  }
}

class _BlocRolesChooserContainer extends StatelessWidget {
  const _BlocRolesChooserContainer();

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
        return RolesChooserContainer(
          selected: state.selected,
          lockedValuesAsDefault: state.defaultRoles,
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
