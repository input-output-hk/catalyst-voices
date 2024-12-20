import 'package:catalyst_voices_models/src/document_builder/document_definitions.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

class DocumentSchema extends Equatable {
  final String schema;
  final String title;
  final String description;
  final List<DocumentSchemaSegment> segments;
  final List<String> order;
  final String propertiesSchema;

  const DocumentSchema({
    required this.schema,
    required this.title,
    required this.description,
    required this.segments,
    required this.order,
    required this.propertiesSchema,
  });

  @override
  List<Object?> get props => [
        schema,
        title,
        description,
        segments,
        order,
        propertiesSchema,
      ];
}

class DocumentSchemaSegment extends Equatable {
  final BaseDocumentDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<DocumentSchemaSection> sections;

  const DocumentSchemaSegment({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.sections,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        sections,
      ];
}

class DocumentSchemaSection extends Equatable {
  final BaseDocumentDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<DocumentSchemaElement> elements;
  final bool isRequired;

  const DocumentSchemaSection({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.elements,
    required this.isRequired,
  });

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        elements,
        isRequired,
      ];
}

class DocumentSchemaElement extends Equatable {
  final BaseDocumentDefinition ref;
  final String id;
  final String title;
  final String description;

  final String? defaultValue;
  final String guidance;
  final List<String> enumValues;
  final Range<int>? range;
  final Range<int>? itemsRange;

  const DocumentSchemaElement({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.defaultValue,
    required this.guidance,
    this.enumValues = const <String>[],
    required this.range,
    required this.itemsRange,
  });

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        defaultValue,
        guidance,
        enumValues,
        range,
        itemsRange,
      ];
}
