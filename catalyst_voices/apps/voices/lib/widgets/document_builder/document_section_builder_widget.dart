import 'package:catalyst_voices/widgets/document_builder/document_property_builder.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Displays a [DocumentSection] and it's properties in editing (builder) mode.
class DocumentSectionBuilderWidget extends StatefulWidget {
  /// A section of the document that groups [DocumentProperty].
  final DocumentSection section;

  /// A callback that should be called with a list of [DocumentChange]
  /// when the user wants to save the changes.
  ///
  /// Sections should collect changes from underlying
  /// [DocumentPropertyBuilderWidget], show "Save" button and only call
  /// this callback when user wants to save the whole section.
  final ValueChanged<List<DocumentChange>> onChanged;

  const DocumentSectionBuilderWidget({
    super.key,
    required this.section,
    required this.onChanged,
  });

  @override
  State<DocumentSectionBuilderWidget> createState() =>
      _DocumentSectionBuilderWidgetState();
}

class _DocumentSectionBuilderWidgetState
    extends State<DocumentSectionBuilderWidget> {
  late DocumentSection _editedSection;
  late DocumentSectionBuilder _builder;
  final _pendingChanges = <DocumentChange>[];

  @override
  void initState() {
    super.initState();

    _editedSection = widget.section;
    _builder = _editedSection.toBuilder();
  }

  @override
  void didUpdateWidget(DocumentSectionBuilderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.section != widget.section) {
      _editedSection = widget.section;
      _builder = _editedSection.toBuilder();
      _pendingChanges.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO(dtscalac): implement the section layout, remove this placeholder
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white,
      ),
      child: Column(
        children: [
          for (final property in widget.section.properties)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DocumentPropertyBuilderWidget(
                property: property,
                onChanged: _onChanged,
              ),
            ),
          if (_pendingChanges.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text('Save'),
              ),
            ),
        ],
      ),
    );
  }

  void _onChanged(DocumentChange change) {
    setState(() {
      _builder.addChange(change);
      _editedSection = _builder.build();
      _pendingChanges.add(change);
    });
  }

  void _onSave() {
    widget.onChanged(List.of(_pendingChanges));

    // ignore: unnecessary_lambdas
    setState(() {
      _pendingChanges.clear();
    });
  }
}
