import 'package:catalyst_voices/widgets/widgets.dart';
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
  final ValueChanged<EditableTileChange>? onChanged;
  final Widget child;

  const EditableTile({
    super.key,
    required this.title,
    this.isEditMode = false,
    this.isSaveEnabled = false,
    this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PropertyTile(
      title: title,
      action: VoicesEditSaveButton(
        onTap: _toggleEditMode,
        isEditing: isEditMode,
      ),
      footer: isEditMode
          ? _Footer(
              isSaveEnabled: isSaveEnabled,
              onSave: _save,
            )
          : null,
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

class _Footer extends StatelessWidget {
  final bool isSaveEnabled;
  final VoidCallback onSave;

  const _Footer({
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
