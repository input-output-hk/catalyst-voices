import 'package:catalyst_voices/widgets/document_builder/document_token_value_widget.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Displays a [DocumentSection] as list tile in edit / view mode.
class DocumentBuilderSectionTile extends StatefulWidget {
  /// A section of the document that groups [DocumentProperty].
  final DocumentSection section;

  /// A callback that should be called with a list of [DocumentChange]
  /// when the user wants to save the changes.
  ///
  /// Sections should collect changes from underlying
  /// property builder, show "Save" button and only call
  /// this callback when user wants to save the whole section.
  /// (Usually single property)
  final ValueChanged<List<DocumentChange>> onChanged;

  const DocumentBuilderSectionTile({
    required super.key,
    required this.section,
    required this.onChanged,
  });

  @override
  State<DocumentBuilderSectionTile> createState() {
    return _DocumentBuilderSectionTileState();
  }
}

class _DocumentBuilderSectionTileState
    extends State<DocumentBuilderSectionTile> {
  late DocumentSection _editedSection;
  late DocumentSectionBuilder _builder;

  final _pendingChanges = <DocumentChange>[];

  bool _isEditMode = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();

    _editedSection = widget.section;
    _builder = _editedSection.toBuilder();

    // TODO(damian-molinski): validation
    _isValid =
        _editedSection.properties.every((element) => element.value != null);
  }

  @override
  void didUpdateWidget(DocumentBuilderSectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.section != widget.section) {
      _editedSection = widget.section;
      _builder = _editedSection.toBuilder();
      _pendingChanges.clear();

      // TODO(damian-molinski): validation
      _isValid =
          _editedSection.properties.every((element) => element.value != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _editedSection.schema.title ?? '';

    return SelectableTile(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              title: title,
              isEditMode: _isEditMode,
              onToggleEditMode: _toggleEditMode,
            ),
            for (final property in widget.section.properties) ...[
              const SizedBox(height: 8),
              _PropertyBuilder(
                key: ObjectKey(property.schema.nodeId),
                property: property,
                isEditMode: _isEditMode,
                onChanged: _handlePropertyChange,
              ),
            ],
            if (_isEditMode) ...[
              const SizedBox(height: 12),
              _Footer(
                isValid: _isValid,
                onSave: _saveChanges,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    widget.onChanged(List.of(_pendingChanges));

    // ignore: unnecessary_lambdas
    setState(() {
      _pendingChanges.clear();
      _isEditMode = false;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      _pendingChanges.clear();
    });
  }

  void _handlePropertyChange(DocumentChange change) {
    setState(() {
      _builder.addChange(change);
      _editedSection = _builder.build();
      _pendingChanges.add(change);

      // TODO(damian-molinski): validation
      _isValid =
          _editedSection.properties.every((element) => element.value != null);
    });
  }
}

class _Header extends StatelessWidget {
  final String? title;
  final bool isEditMode;
  final VoidCallback? onToggleEditMode;

  const _Header({
    this.title,
    this.isEditMode = false,
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
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isValid;
  final VoidCallback onSave;

  const _Footer({
    required this.isValid,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: VoicesFilledButton(
        onTap: isValid ? onSave : null,
        child: Text(context.l10n.saveButtonText.toUpperCase()),
      ),
    );
  }
}

class _PropertyBuilder extends StatelessWidget {
  final DocumentProperty property;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const _PropertyBuilder({
    required super.key,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (property.schema.definition) {
      case SegmentDefinition():
      case SectionDefinition():
        throw UnsupportedError(
          '${property.schema.definition} unsupported '
          'by $DocumentBuilderSectionTile',
        );
      case SingleLineTextEntryDefinition():
      case SingleLineHttpsURLEntryDefinition():
      case MultiLineTextEntryDefinition():
      case MultiLineTextEntryMarkdownDefinition():
      case DropDownSingleSelectDefinition():
      case MultiSelectDefinition():
      case SingleLineTextEntryListDefinition():
      case MultiLineTextEntryListMarkdownDefinition():
      case SingleLineHttpsURLEntryListDefinition():
      case NestedQuestionsListDefinition():
      case NestedQuestionsDefinition():
      case SingleGroupedTagSelectorDefinition():
      case TagGroupDefinition():
      case TagSelectionDefinition():
      case TokenValueCardanoADADefinition():
        return DocumentTokenValueWidget(
          id: property.schema.nodeId,
          label: property.schema.title ?? '',
          value: property.value is int ? property.value! as int : null,
          currency: const Currency.ada(),
          range: property.schema.range,
          isEditMode: isEditMode,
          isRequired: property.schema.isRequired,
          onChanged: onChanged,
        );
      case DurationInMonthsDefinition():
      case YesNoChoiceDefinition():
      case AgreementConfirmationDefinition():
      case SPDXLicenceOrUrlDefinition():
        throw UnimplementedError();
    }
  }
}
