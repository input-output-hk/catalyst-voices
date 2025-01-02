import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentPropertyFooter extends StatelessWidget {
  final VoidCallback? onSave;

  const DocumentPropertyFooter({
    super.key,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      alignment: Alignment.centerRight,
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      child: VoicesFilledButton(
        onTap: onSave,
        child: Text(context.l10n.saveButtonText.toUpperCase()),
      ),
    );
  }
}
