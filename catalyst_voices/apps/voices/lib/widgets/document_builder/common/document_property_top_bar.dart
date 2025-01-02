import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentPropertyTopBar extends StatelessWidget {
  final String? title;
  final bool isEditMode;
  final VoidCallback? onToggleEditMode;

  const DocumentPropertyTopBar({
    super.key,
    this.title,
    required this.isEditMode,
    this.onToggleEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 16),
        VoicesTextButton(
          onTap: onToggleEditMode,
          child: Text(
            isEditMode
                ? context.l10n.cancelButtonText
                : context.l10n.editButtonText,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
