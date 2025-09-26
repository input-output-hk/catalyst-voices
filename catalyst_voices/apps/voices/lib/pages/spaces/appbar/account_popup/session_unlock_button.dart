import 'dart:async';

import 'package:catalyst_voices/pages/account/unlock_keychain_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_responsive_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SessionUnlockButton extends StatelessWidget {
  const SessionUnlockButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesResponsiveOutlinedButton(
      key: const Key('UnlockButton'),
      onTap: () => unawaited(UnlockKeychainDialog.show(context)),
      icon: VoicesAssets.icons.lockOpen.buildIcon(),
      child: Text(context.l10n.unlock),
    );
  }
}
