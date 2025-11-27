import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

const _collaboratorsSectionNodeId = 'setup.collaborators';

final class CollaboratorsSection extends DocumentSection {
  static const kDefaultMaxCollaborators = 5;

  final CatalystId? authorId;
  final List<CatalystId> collaborators;
  final int maxCollaborators;

  const CollaboratorsSection({
    required super.id,
    required this.authorId,
    required this.collaborators,
    this.maxCollaborators = kDefaultMaxCollaborators,
    required super.property,
    required super.schema,
  });

  /// Creates a CollaboratorsSection with minimal dummy property/schema.
  factory CollaboratorsSection.create({
    required CatalystId? authorId,
    required List<CatalystId> collaborators,
    int maxCollaborators = kDefaultMaxCollaborators,
  }) {
    final nodeId = DocumentNodeId.fromString(_collaboratorsSectionNodeId);
    final schema = DocumentGenericObjectSchema(
      nodeId: nodeId,
      format: null,
      title: 'Co-Proposers',
      description: null,
      placeholder: null,
      guidance: null,
      isSubsection: false,
      isRequired: false,
      properties: const [],
      oneOf: const [],
      order: const [],
    );

    return CollaboratorsSection(
      id: nodeId,
      authorId: authorId,
      collaborators: collaborators,
      maxCollaborators: maxCollaborators,
      property: DocumentObjectProperty(
        schema: schema,
        properties: const [],
        validationResult: const SuccessfulDocumentValidation(),
      ),
      schema: schema,
    );
  }

  @override
  List<Object?> get props => super.props + [authorId, collaborators, maxCollaborators];

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.collaboratorsSectionTitle;
  }
}

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
