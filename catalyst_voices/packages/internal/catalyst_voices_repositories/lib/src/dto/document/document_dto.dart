import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';

/// A data transfer object for the [Document].
///
/// Encodable as json but to decode with [DocumentDto.fromJsonSchema]
/// a [DocumentSchema] is needed which explains how to interpret the data.
final class DocumentDto {
  final String schemaUrl;
  final DocumentSchema schema;
  final List<DocumentPropertyDto> properties;

  const DocumentDto({
    required this.schemaUrl,
    required this.schema,
    required this.properties,
  });

  factory DocumentDto.fromJsonSchema(
    DocumentDataDto data,
    DocumentSchema schema,
  ) {
    return DocumentDto(
      schemaUrl: data.schemaUrl,
      schema: schema,
      properties: schema.properties
          .map(
            (segment) => DocumentPropertyDto.fromJsonSchema(
              segment,
              data: data,
            ),
          )
          .toList(),
    );
  }

  factory DocumentDto.fromModel(Document model) {
    return DocumentDto(
      schemaUrl: model.schemaUrl,
      schema: model.schema,
      properties: model.properties.map(DocumentPropertyDto.fromModel).toList(),
    );
  }

  Document toModel() {
    // building a document via builder to sort properties
    return DocumentBuilder(
      schemaUrl: schemaUrl,
      schema: schema,
      properties: properties
          .map((e) => DocumentPropertyBuilder.fromProperty(e.toModel()))
          .toList(),
    ).build();
  }

  DocumentDataDto toJson() {
    return DocumentDataDto.fromDocument(
      schemaUrl: schemaUrl,
      properties: properties.map((e) => e.toJson()),
    );
  }
}

sealed class DocumentPropertyDto {
  const DocumentPropertyDto();

  factory DocumentPropertyDto.fromJsonSchema(
    DocumentPropertySchema schema, {
    required DocumentDataDto data,
  }) {
    switch (schema) {
      case DocumentObjectSchema():
        return DocumentPropertyObjectDto.fromJsonSchema(
          schema,
          data: data,
        );
      case DocumentListSchema():
        return DocumentPropertyListDto.fromJsonSchema(
          schema,
          data: data,
        );
      case DocumentValueSchema():
        return DocumentPropertyValueDto.fromJsonSchema(
          schema,
          data: data,
        );
    }
  }

  factory DocumentPropertyDto.fromModel(DocumentProperty property) {
    switch (property) {
      case DocumentListProperty():
        return DocumentPropertyListDto.fromModel(property);
      case DocumentObjectProperty():
        return DocumentPropertyObjectDto.fromModel(property);
      case DocumentValueProperty():
        return DocumentPropertyValueDto.fromModel(property);
    }
  }

  DocumentPropertySchema get schema;

  DocumentProperty toModel();

  Map<String, dynamic> toJson();
}

final class DocumentPropertyListDto extends DocumentPropertyDto {
  @override
  final DocumentListSchema schema;
  final List<DocumentPropertyDto> properties;

  const DocumentPropertyListDto({
    required this.schema,
    required this.properties,
  });

  factory DocumentPropertyListDto.fromJsonSchema(
    DocumentListSchema schema, {
    required DocumentDataDto data,
  }) {
    final values = data.getProperty(schema.nodeId) as List? ?? [];
    final itemsSchema = schema.itemsSchema;

    return DocumentPropertyListDto(
      schema: schema,
      properties: [
        for (int i = 0; i < values.length; i++)
          DocumentPropertyDto.fromJsonSchema(
            itemsSchema.withNodeId(schema.nodeId.child('$i')),
            data: data,
          ),
      ],
    );
  }

  factory DocumentPropertyListDto.fromModel(DocumentListProperty model) {
    return DocumentPropertyListDto(
      schema: model.schema,
      properties: model.properties.map(DocumentPropertyDto.fromModel).toList(),
    );
  }

  @override
  DocumentListProperty toModel() {
    final mappedProperties = properties.map((e) => e.toModel()).toList();

    return schema.buildProperty(
      properties: List.unmodifiable(mappedProperties),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        schema.id: [
          for (final property in properties) ...property.toJson().values,
        ],
      };
}

final class DocumentPropertyObjectDto extends DocumentPropertyDto {
  @override
  final DocumentObjectSchema schema;
  final List<DocumentPropertyDto> properties;

  const DocumentPropertyObjectDto({
    required this.schema,
    required this.properties,
  });

  factory DocumentPropertyObjectDto.fromJsonSchema(
    DocumentObjectSchema schema, {
    required DocumentDataDto data,
  }) {
    return DocumentPropertyObjectDto(
      schema: schema,
      properties: schema.properties.map((childSchema) {
        return DocumentPropertyDto.fromJsonSchema(
          childSchema,
          data: data,
        );
      }).toList(),
    );
  }

  factory DocumentPropertyObjectDto.fromModel(DocumentObjectProperty model) {
    return DocumentPropertyObjectDto(
      schema: model.schema,
      properties: model.properties.map(DocumentPropertyDto.fromModel).toList(),
    );
  }

  @override
  DocumentObjectProperty toModel() {
    final mappedProperties = properties.map((e) => e.toModel()).toList();

    return schema.buildProperty(
      properties: List.unmodifiable(mappedProperties),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        schema.id: {
          for (final property in properties) ...property.toJson(),
        },
      };
}

final class DocumentPropertyValueDto<T extends Object>
    extends DocumentPropertyDto {
  @override
  final DocumentValueSchema<T> schema;
  final T? value;

  const DocumentPropertyValueDto({
    required this.schema,
    required this.value,
  });

  factory DocumentPropertyValueDto.fromJsonSchema(
    DocumentValueSchema<T> schema, {
    required DocumentDataDto data,
  }) {
    final property = data.getProperty(schema.nodeId);
    return DocumentPropertyValueDto<T>(
      schema: schema,
      value: property as T?,
    );
  }

  factory DocumentPropertyValueDto.fromModel(DocumentValueProperty<T> model) {
    return DocumentPropertyValueDto<T>(
      schema: model.schema,
      value: model.value,
    );
  }

  @override
  DocumentValueProperty<T> toModel() {
    return schema.buildProperty(value: value);
  }

  @override
  Map<String, dynamic> toJson() => {
        schema.id: value,
      };
}
