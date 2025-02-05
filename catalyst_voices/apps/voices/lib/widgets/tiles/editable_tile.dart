import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum EditableTileChangeSource { cancel, save }

typedef EditableTileChange = ({
  bool isEditMode,
  EditableTileChangeSource source,
});

class EditableTile extends StatefulWidget {
  final String title;
  final bool initialEditMode;
  final bool isSaveEnabled;
  final ValueChanged<EditableTileChange>? onChanged;
  final Widget child;

  const EditableTile({
    super.key,
    required this.title,
    this.initialEditMode = false,
    this.isSaveEnabled = false,
    this.onChanged,
    required this.child,
  });

  @override
  State<EditableTile> createState() => _EditableTileState();
}

class _EditableTileState extends State<EditableTile> {
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.initialEditMode;
  }

  @override
  Widget build(BuildContext context) {
    return PropertyTile(
      title: widget.title,
      action: VoicesEditSaveButton(
        onTap: _toggleEditMode,
        isEditing: _isEditMode,
      ),
      footer: _isEditMode
          ? _Footer(
              isSaveEnabled: widget.isSaveEnabled,
              onSave: _save,
            )
          : null,
      child: widget.child,
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;

      final onChanged = widget.onChanged;
      if (onChanged != null) {
        final change = (
          isEditMode: _isEditMode,
          source: EditableTileChangeSource.cancel,
        );
        onChanged(change);
      }
    });
  }

  void _save() {
    setState(() {
      _isEditMode = false;
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        final change = (
          isEditMode: _isEditMode,
          source: EditableTileChangeSource.save,
        );
        onChanged(change);
      }
    });
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
