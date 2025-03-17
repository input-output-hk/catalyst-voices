import 'package:catalyst_voices/widgets/document_builder/document_list_property_builder.dart';
import 'package:catalyst_voices/widgets/document_builder/document_object_property_builder.dart';
import 'package:catalyst_voices/widgets/document_builder/document_value_property_builder.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    hide
        DocumentListPropertyBuilder,
        DocumentObjectPropertyBuilder,
        DocumentValuePropertyBuilder;
import 'package:flutter/material.dart';

class DocumentPropertyBuilder extends StatelessWidget {
  final DocumentProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const DocumentPropertyBuilder({
    required super.key,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final property = this.property;
    switch (property) {
      case DocumentListProperty():
        return DocumentListPropertyBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentObjectProperty():
        return DocumentObjectPropertyBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentValueProperty():
        return DocumentValuePropertyBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
    }
  }
}
