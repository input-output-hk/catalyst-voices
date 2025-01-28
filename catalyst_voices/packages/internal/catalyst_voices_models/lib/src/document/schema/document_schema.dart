import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A document schema that describes the structure of a document.
///
/// The document consists of top level [properties].
/// [properties] contain [DocumentSegmentSchema.sections]
/// and sections contain [DocumentPropertySchema]'s.
final class DocumentSchema extends Equatable implements DocumentNode {
  /// The url of the schema which this document schema follows.
  final String parentSchemaUrl;

  /// The url to this schema.
  final String schemaSelfUrl;
  final String title;
  final MarkdownData description;
  final List<DocumentPropertySchema> properties;
  final List<DocumentNodeId> order;

  const DocumentSchema({
    required this.parentSchemaUrl,
    required this.schemaSelfUrl,
    required this.title,
    required this.description,
    required this.properties,
    required this.order,
  });

  const DocumentSchema.optional({
    this.parentSchemaUrl = '',
    this.schemaSelfUrl = '',
    this.title = '',
    this.description = MarkdownData.empty,
    this.properties = const [],
    this.order = const [],
  });

  @override
  DocumentNodeId get nodeId => DocumentNodeId.root;

  List<DocumentSegmentSchema> get segments =>
      properties.whereType<DocumentSegmentSchema>().toList();

  @override
  List<Object?> get props => [
        parentSchemaUrl,
        schemaSelfUrl,
        title,
        description,
        properties,
        order,
      ];
}

final class DocumentSchemaLogicalGroup extends Equatable {
  final List<DocumentSchemaLogicalCondition> conditions;

  const DocumentSchemaLogicalGroup({
    required this.conditions,
  });

  @override
  List<Object?> get props => [
        conditions,
      ];
}

final class DocumentSchemaLogicalCondition extends Equatable {
  final DocumentPropertySchema schema;
  final Object? constValue;
  final List<Object>? enumValues;

  const DocumentSchemaLogicalCondition({
    required this.schema,
    required this.constValue,
    required this.enumValues,
  });

  @override
  List<Object?> get props => [
        schema,
        constValue,
        enumValues,
      ];
}
