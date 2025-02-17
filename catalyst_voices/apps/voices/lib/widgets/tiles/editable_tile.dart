import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum EditableTileChangeSource { cancel, save }

typedef EditableTileChange = ({
  bool isEditMode,
  EditableTileChangeSource source,
});

class EditableTile extends StatelessWidget {
  final String title;
  final bool isEditMode;
  final bool isSaveEnabled;
  final String? errorText;
  final ValueChanged<EditableTileChange>? onChanged;
  final Widget child;

  const EditableTile({
    super.key,
    required this.title,
    this.isEditMode = false,
    this.isSaveEnabled = false,
    this.errorText,
    this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final errorText = this.errorText;

    final Widget? footer;
    if (isEditMode) {
      footer = _SaveFooter(
        isSaveEnabled: isSaveEnabled,
        onSave: _save,
      );
    } else if (errorText != null) {
      footer = _ErrorFooter(errorText: errorText);
    } else {
      footer = null;
    }

    return PropertyTile(
      title: title,
      action: VoicesEditSaveButton(
        onTap: _toggleEditMode,
        isEditing: isEditMode,
      ),
      footer: footer,
      child: child,
    );
  }

  void _toggleEditMode() {
    final change = (
      isEditMode: !isEditMode,
      source: EditableTileChangeSource.cancel,
    );

    onChanged?.call(change);
  }

  void _save() {
    const change = (
      isEditMode: false,
      source: EditableTileChangeSource.save,
    );

    onChanged?.call(change);
  }
}

class _SaveFooter extends StatelessWidget {
  final bool isSaveEnabled;
  final VoidCallback onSave;

  const _SaveFooter({
    required this.isSaveEnabled,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: VoicesFilledButton(
        onTap: isSaveEnabled ? onSave : null,
        child: Text(context.l10n.saveButtonText.toUpperCase()),
      ),
    );
  }
}

class _ErrorFooter extends StatelessWidget {
  final String errorText;

  const _ErrorFooter({
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.iconsError;
    return Row(
      spacing: 10,
      children: [
        VoicesAssets.icons.exclamationCircle.buildIcon(
          size: 24,
          color: color,
        ),
        Flexible(
          child: Text(
            errorText,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
