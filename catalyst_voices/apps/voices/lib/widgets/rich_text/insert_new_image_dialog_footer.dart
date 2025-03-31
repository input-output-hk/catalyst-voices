import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InsertNewImageDialogFooter extends StatelessWidget {
  final bool isValidImageUrl;
  final bool inputFieldIsEmpty;
  final VoidCallback onInserImage;

  const InsertNewImageDialogFooter({
    required this.isValidImageUrl,
    required this.inputFieldIsEmpty,
    required this.onInserImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButtonText),
          ),
          const SizedBox(width: 8),
          VoicesFilledButton(
            onTap: !inputFieldIsEmpty && isValidImageUrl ? onInserImage : null,
            child: Text(l10n.insertNewImageDialogInsertButtonText),
          ),
        ],
      ),
    );
  }
}
