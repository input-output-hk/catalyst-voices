import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/containers/roles_chooser_container.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

        return RolesChooserContainer(
          selected: selectedRoles ?? defaultRoles,
          lockedValuesAsDefault: defaultRoles,
          onChanged: RegistrationCubit.of(context).selectRoles,
        );
      },
    );
  }
}
