import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class AccountCompletedPicture extends StatelessWidget {
  const AccountCompletedPicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CatalystImage.asset(
      VoicesAssets.images.welcomeIllustration.path,
    );
  }
}
