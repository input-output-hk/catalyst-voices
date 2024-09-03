import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class LeftArrowButton extends StatelessWidget {
  final VoidCallback? onTap;

  const LeftArrowButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: const Icon(CatalystVoicesIcons.arrow_narrow_left),
    );
  }
}

class RightArrowButton extends StatelessWidget {
  final VoidCallback? onTap;

  const RightArrowButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: const Icon(CatalystVoicesIcons.arrow_narrow_right),
    );
  }
}
