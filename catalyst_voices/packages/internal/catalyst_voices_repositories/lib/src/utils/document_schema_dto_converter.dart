import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_logical_property_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_section_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_segment_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

final class DocumentSchemaSegmentsDtoConverter
    implements
        JsonConverter<List<DocumentSchemaSegmentDto>, Map<String, dynamic>?> {
  const DocumentSchemaSegmentsDtoConverter();

  @override
  List<DocumentSchemaSegmentDto> fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return [];
    }

    final properties = json.convertMapToListWithIds();
    return properties.map(DocumentSchemaSegmentDto.fromJson).toList();
  }

  @override
  Map<String, dynamic>? toJson(List<DocumentSchemaSegmentDto> segments) {
    return {
      for (final segment in segments) segment.id: segment.toJson(),
    };
  }
}

final class DocumentSchemaSectionsDtoConverter
    implements
        JsonConverter<List<DocumentSchemaSectionDto>, Map<String, dynamic>?> {
  const DocumentSchemaSectionsDtoConverter();

  @override
  List<DocumentSchemaSectionDto> fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return [];
    }

    final properties = json.convertMapToListWithIds();
    return properties.map(DocumentSchemaSectionDto.fromJson).toList();
  }

  @override
  Map<String, dynamic>? toJson(List<DocumentSchemaSectionDto> sections) {
    return {
      for (final section in sections) section.id: section.toJson(),
    };
  }
}

final class DocumentSchemaLogicalPropertiesDtoConverter
    implements
        JsonConverter<List<DocumentSchemaLogicalConditionDto>,
            Map<String, dynamic>> {
  const DocumentSchemaLogicalPropertiesDtoConverter();

  @override
  List<DocumentSchemaLogicalConditionDto> fromJson(Map<String, dynamic> json) {
    final properties = json.convertMapToListWithIds();
    return properties.map(DocumentSchemaLogicalConditionDto.fromJson).toList();
  }

  @override
  Map<String, dynamic> toJson(
    List<DocumentSchemaLogicalConditionDto> properties,
  ) {
    return {
      for (final property in properties) property.id: property.toJson(),
    };
  }
}
