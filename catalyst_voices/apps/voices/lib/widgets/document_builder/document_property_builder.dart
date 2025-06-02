import 'package:catalyst_voices/widgets/document_builder/document_list_property_builder.dart';
import 'package:catalyst_voices/widgets/document_builder/document_object_property_builder.dart';
import 'package:catalyst_voices/widgets/document_builder/document_value_property_builder.dart';
import 'package:catalyst_voices/widgets/tiles/property_tile.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    hide DocumentListPropertyBuilder, DocumentObjectPropertyBuilder, DocumentValuePropertyBuilder;
import 'package:flutter/material.dart';

/// A map defining overrides for the [PropertyTile.action].
///
/// Instead of building a predefined widget it is
/// possible to override it for given [DocumentNodeId].
typedef DocumentPropertyActionOverrides = Map<DocumentNodeId, Widget>;

/// A map defining overrides for the [DocumentPropertyBuilder].
///
/// Instead of building a predefined widget it is
/// possible to override it for given [DocumentNodeId].
typedef DocumentPropertyBuilderOverrides = Map<DocumentNodeId, DocumentPropertyWidgetBuilder>;

/// A callback that builds a widget for given document [property].
typedef DocumentPropertyWidgetBuilder = Widget Function(
  BuildContext context,
  DocumentProperty property,
);

class DocumentPropertyBuilder extends StatelessWidget {
  final DocumentProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;
  final DocumentPropertyBuilderOverrides? overrides;

  const DocumentPropertyBuilder({
    required super.key,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
    this.overrides,
  });

  @override
  Widget build(BuildContext context) {
    final property = this.property;
    final overrideBuilder = _getOverrideBuilder(property.nodeId);
    if (overrideBuilder != null) {
      return overrideBuilder(context, property);
    }

    switch (property) {
      case DocumentListProperty():
        return DocumentListPropertyBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
          overrides: overrides,
        );
      case DocumentObjectProperty():
        return DocumentObjectPropertyBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
          overrides: overrides,
        );
      case DocumentValueProperty():
        return DocumentValuePropertyBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
    }
  }

  DocumentPropertyWidgetBuilder? _getOverrideBuilder(DocumentNodeId nodeId) {
    final overrides = this.overrides;
    if (overrides == null) return null;

    return overrides[nodeId];
  }
}
