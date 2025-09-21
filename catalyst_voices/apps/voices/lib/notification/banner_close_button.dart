import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BannerCloseButton extends StatelessWidget {
  const BannerCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      style: const ButtonStyle(iconSize: WidgetStatePropertyAll(18)),
      onTap: () {
        final messengerState = AppContent.scaffoldMessengerKey.currentState;
        if (messengerState == null) {
          if (kDebugMode) {
            print('Can not dismiss banner because messenger key state is empty!');
          }
          return;
        }

        messengerState.hideCurrentMaterialBanner(reason: MaterialBannerClosedReason.dismiss);
      },
      child: VoicesAssets.icons.x.buildIcon(),
    );
  }
}
