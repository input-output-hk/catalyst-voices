import 'package:catalyst_voices/widgets/document_builder/viewer/document_property_builder_viewer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' as model;
import 'package:flutter/material.dart';

/// Displays a [model.DocumentSectionSchema] as list tile in edit / view mode.
class DocumentBuilderSectionTile extends StatefulWidget {
  /// A section of the document that groups [model.DocumentValueProperty].
  final model.DocumentProperty section;

  /// True if the section is currently selected.
  final bool isSelected;

  /// True if the section can be edited, false if it is view-only.
  final bool isEditable;

  /// The mode for the validation in this section.
  final AutovalidateMode autovalidateMode;

  /// A callback that should be called with a list of [model.DocumentChange]
  /// when the user wants to save the changes.
  ///
  /// Sections should collect changes from underlying
  /// property builder, show "Save" button and only call
  /// this callback when user wants to save the whole section.
  /// (Usually single property)
  final ValueChanged<List<model.DocumentChange>> onChanged;

  /// See [DocumentPropertyBuilderOverrides].
  final DocumentPropertyBuilderOverrides? overrides;

  const DocumentBuilderSectionTile({
    required super.key,
    required this.section,
    this.isSelected = false,
    this.isEditable = true,
    this.autovalidateMode = AutovalidateMode.disabled,
    required this.onChanged,
    this.overrides,
  });

  @override
  State<DocumentBuilderSectionTile> createState() {
    return _DocumentBuilderSectionTileState();
  }
}

class _DocumentBuilderSectionTileState
    extends State<DocumentBuilderSectionTile> {
  final _formKey = GlobalKey<FormState>();

  late model.DocumentProperty _editedSection;
  late model.DocumentPropertyBuilder _builder;

  final _pendingChanges = <model.DocumentChange>[];

  bool _isEditMode = false;

  String? get _errorText {
    if (widget.autovalidateMode == AutovalidateMode.always &&
        !_editedSection.isValidExcludingSubsections) {
      return context.l10n.sectionHasErrorsMessage;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final title = _editedSection.schema.title;

    return EditableTile(
      title: title,
      isSelected: widget.isSelected,
      isEditMode: _isEditMode,
      isSaveEnabled: true,
      isEditEnabled: widget.isEditable,
      saveText: context.l10n.saveChangesButtonText,
      errorText: _errorText,
      saveButtonLeading: VoicesAssets.icons.check.buildIcon(),
      editCancelButtonStyle: VoicesEditCancelButtonStyle.outlinedWithIcon,
      onChanged: _onEditModeChange,
      child: Form(
        key: _formKey,
        autovalidateMode: widget.autovalidateMode,
        child: _isEditMode
            ? DocumentPropertyBuilder(
                key: ValueKey(_editedSection.schema.nodeId),
                property: _editedSection,
                isEditMode: _isEditMode,
                onChanged: _handlePropertyChanges,
                overrides: widget.overrides,
              )
            : DocumentPropertyBuilderViewer(
                key: ValueKey(_editedSection.schema.nodeId),
                property: _editedSection,
                overrides: widget.overrides,
              ),
      ),
    );
  }

  @override
  void didUpdateWidget(DocumentBuilderSectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isEditable && oldWidget.isEditable) {
      _isEditMode = false;
      _resetBuilder();
    } else if (oldWidget.section != widget.section) {
      _resetBuilder();
    }
  }

  @override
  void initState() {
    super.initState();

    _editedSection = widget.section;
    _builder = _editedSection.toBuilder();
  }

  void _handlePropertyChanges(List<model.DocumentChange> changes) {
    setState(() {
      for (final change in changes) {
        _builder.addChange(change);
      }
      _editedSection = _builder.build();
      _pendingChanges.addAll(changes);
    });
  }

  void _onCancel() {
    setState(() {
      _resetBuilder();
      _isEditMode = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Need to reset after the frame because first we need
      // to revert the original values (which is done in setState()),
      // then the widgets need to rebuild with these values
      // and only then we can reset the validation error.
      _formKey.currentState?.reset();
    });
  }

  void _onEditModeChange(EditableTileChange value) {
    switch (value.source) {
      case EditableTileChangeSource.cancel:
        if (!value.isEditMode) {
          _onCancel();
        } else {
          setState(() {
            _isEditMode = value.isEditMode;
          });
        }

      case EditableTileChangeSource.save:
        _formKey.currentState!.validate();
        _onSave();
    }
  }

  void _onSave() {
    setState(() {
      widget.onChanged(List.of(_pendingChanges));
      _pendingChanges.clear();
      _isEditMode = false;
    });
  }

  void _resetBuilder() {
    _editedSection = widget.section;
    _builder = _editedSection.toBuilder();
    _pendingChanges.clear();
  }
}
