import 'package:catalyst_voices/app/app.dart';
import 'package:flutter/material.dart';

class BannerCloseButton extends StatelessWidget {
  const BannerCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AppContent.scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner(
          reason: MaterialBannerClosedReason.dismiss,
        );
      },
      icon: const Icon(Icons.close),
    );
  }
}
