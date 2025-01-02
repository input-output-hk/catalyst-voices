import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentPropertyFooter extends StatelessWidget {
  final VoidCallback? onSave;
  final EdgeInsetsGeometry? padding;

  const DocumentPropertyFooter({
    super.key,
    this.onSave,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.centerRight,
      child: VoicesFilledButton(
        onTap: onSave,
        child: Text(context.l10n.saveButtonText.toUpperCase()),
      ),
    );
  }
}
