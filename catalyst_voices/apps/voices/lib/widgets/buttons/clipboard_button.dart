import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A clipboard icon button that copies [clipboardData]
/// into Clipboard after it's clicked.
class VoicesClipboardIconButton extends StatelessWidget {
  final String clipboardData;

  const VoicesClipboardIconButton({
    super.key,
    required this.clipboardData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(
          ClipboardData(text: clipboardData),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: VoicesAssets.icons.clipboardCopy.buildIcon(size: 16),
      ),
    );
  }
}
