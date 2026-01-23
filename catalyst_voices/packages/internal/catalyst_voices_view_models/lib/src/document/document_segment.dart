import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Represent a document section from a document template
final class DocumentSection extends BaseSection {
  final DocumentProperty property;
  final DocumentPropertySchema schema;

  const DocumentSection({
    required super.id,
    required this.property,
    required this.schema,
    super.isEnabled,
    super.isEditable,
    super.hasError,
  });

  @override
  List<Object?> get props => super.props + [property, schema];

  @override
  String resolveTitle(BuildContext context) {
    return property.schema.title;
  }
}

/// Represent a document segment from a document template
final class DocumentSegment extends BaseSegment<DocumentSection> {
  final DocumentObjectProperty property;
  final DocumentSegmentSchema schema;

  const DocumentSegment({
    required super.id,
    required super.sections,
    required this.property,
    required this.schema,
  });

  @override
  SvgGenImage get icon {
    final iconAsset = schema.icon;
    if (iconAsset != null) {
      return VoicesAssets.icons.getIcon(iconAsset);
    } else {
      return VoicesAssets.icons.viewGrid;
    }
  }

  @override
  List<Object?> get props => super.props + [property, schema];

  @override
  String resolveTitle(BuildContext context) {
    return property.schema.title;
  }
}

extension DocumentExt on Document {
  /// Maps the [Document] model to a list of [DocumentSegment] view models.
  List<DocumentSegment> createSegments({
    bool showValidationErrors = false,
  }) {
    return segments.map((segment) {
      final sections = segment.sections
          .expand(DocumentNodeTraverser.findSectionsAndSubsections)
          .map(
            (section) => DocumentSection(
              id: section.schema.nodeId,
              property: section,
              schema: section.schema,
              hasError: showValidationErrors && !section.isValidExcludingSubsections,
            ),
          )
          .toList();

      return DocumentSegment(
        id: segment.schema.nodeId,
        sections: sections,
        property: segment,
        schema: segment.schema as DocumentSegmentSchema,
      );
    }).toList();
  }
}
