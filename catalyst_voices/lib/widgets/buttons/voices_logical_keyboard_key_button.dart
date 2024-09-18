import 'package:catalyst_voices/widgets/buttons/voices_keyboard_key_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Map<int, SvgGenImage> _keyIconMapping = {
  LogicalKeyboardKey.control.keyId: VoicesAssets.icons.chevronUp,
  LogicalKeyboardKey.controlLeft.keyId: VoicesAssets.icons.chevronUp,
  LogicalKeyboardKey.controlRight.keyId: VoicesAssets.icons.chevronUp,
};

class VoicesLogicalKeyboardKeyButton extends StatelessWidget {
  final LogicalKeyboardKey data;

  const VoicesLogicalKeyboardKeyButton(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesKeyboardKeyButton(
      child: _buildKeyIndicator(context),
    );
  }

  Widget _buildKeyIndicator(BuildContext context) {
    final keyIcon = _keyIconMapping[data.keyId];
    if (keyIcon != null) {
      return keyIcon.buildIcon();
    }

    final keyLabel = data.keyLabel;
    final letter = keyLabel.isNotEmpty ? keyLabel.substring(0, 1) : null;
    if (letter != null) {
      return Text(letter.toUpperCase());
    }

    return const SizedBox.shrink();
  }
}
