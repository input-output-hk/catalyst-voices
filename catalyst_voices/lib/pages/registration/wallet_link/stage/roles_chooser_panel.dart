import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/containers/roles_chooser_container.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class RolesChooserPanel extends StatelessWidget {
  final Set<AccountRole> defaultRoles;
  final Set<AccountRole> selectedRoles;

  const RolesChooserPanel({
    super.key,
    required this.defaultRoles,
    required this.selectedRoles,
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
        RolesChooserContainer(
          selected: selectedRoles,
          lockedValuesAsDefault: defaultRoles,
          onChanged: RegistrationCubit.of(context).selectRoles,
        ),
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
