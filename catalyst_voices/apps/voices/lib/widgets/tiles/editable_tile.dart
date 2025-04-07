import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

typedef EditableTileChange = ({
  bool isEditMode,
  EditableTileChangeSource source,
});

class EditableTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isEditMode;
  final bool isSaveEnabled;
  final bool isEditEnabled;
  final Widget? saveButtonLeading;
  final String? saveText;
  final String? errorText;
  final VoicesEditCancelButtonStyle editCancelButtonStyle;
  final ValueChanged<EditableTileChange>? onChanged;
  final Widget child;

  const EditableTile({
    super.key,
    required this.title,
    this.isSelected = false,
    this.isEditMode = false,
    this.isSaveEnabled = false,
    this.isEditEnabled = true,
    this.saveButtonLeading,
    this.saveText,
    this.errorText,
    this.editCancelButtonStyle = VoicesEditCancelButtonStyle.text,
    this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final showSaveButton = isEditMode;
    final showFooter = showSaveButton || errorText != null;

    return PropertyTile(
      title: title,
      isSelected: isSelected,
      action: Offstage(
        offstage: !isEditEnabled,
        child: VoicesEditCancelButton(
          key: const Key('EditableTileEditCancelButton'),
          style: editCancelButtonStyle,
          onTap: _toggleEditMode,
          isEditing: isEditMode,
          hasError: errorText != null,
        ),
      ),
      footer: showFooter
          ? _Footer(
              saveButtonLeading: saveButtonLeading,
              saveText: saveText,
              errorText: errorText,
              showSaveButton: showSaveButton,
              isSaveEnabled: isSaveEnabled,
              onSave: _save,
            )
          : null,
      child: child,
    );
  }

  void _save() {
    const change = (
      isEditMode: false,
      source: EditableTileChangeSource.save,
    );

    onChanged?.call(change);
  }

  void _toggleEditMode() {
    final change = (
      isEditMode: !isEditMode,
      source: EditableTileChangeSource.cancel,
    );

    onChanged?.call(change);
  }
}

enum EditableTileChangeSource { cancel, save }

class _ErrorText extends StatelessWidget {
  final String text;

  const _ErrorText({
    required this.text,
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
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final Widget? saveButtonLeading;
  final String? saveText;
  final String? errorText;
  final bool showSaveButton;
  final bool isSaveEnabled;
  final VoidCallback onSave;

  const _Footer({
    required this.saveButtonLeading,
    required this.saveText,
    required this.errorText,
    required this.showSaveButton,
    required this.isSaveEnabled,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final errorText = this.errorText;

    return Row(
      children: [
        Expanded(
          child: errorText != null
              ? _ErrorText(text: errorText)
              : const SizedBox.shrink(),
        ),
        Visibility.maintain(
          visible: showSaveButton,
          child: VoicesFilledButton(
            key: const Key('EmailTileSaveButton'),
            onTap: isSaveEnabled ? onSave : null,
            leading: saveButtonLeading,
            child: Text(
              saveText ?? context.l10n.saveButtonText.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
