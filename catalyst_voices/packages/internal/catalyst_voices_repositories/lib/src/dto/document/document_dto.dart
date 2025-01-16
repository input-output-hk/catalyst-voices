import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_properties_dto.dart';

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
    Map<String, dynamic> json,
    DocumentSchema schema,
  ) {
    final properties = DocumentPropertiesDto.fromJson(json);

    return DocumentDto(
      schemaUrl: json[r'$schema'] as String,
      schema: schema,
      properties: schema.properties
          .map(
            (segment) => DocumentPropertyDto.fromJsonSchema(
              segment,
              properties: properties,
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

  Map<String, dynamic> toJson() {
    return {
      r'$schema': schemaUrl,
      for (final property in properties) ...property.toJson(),
    };
  }
}

sealed class DocumentPropertyDto {
  const DocumentPropertyDto();

  factory DocumentPropertyDto.fromJsonSchema(
    DocumentPropertySchema schema, {
    required DocumentPropertiesDto properties,
  }) {
    switch (schema) {
      case DocumentObjectSchema():
        return DocumentPropertyObjectDto.fromJsonSchema(
          schema,
          properties: properties,
        );
      case DocumentListSchema():
        return DocumentPropertyListDto.fromJsonSchema(
          schema,
          properties: properties,
        );
      case DocumentValueSchema():
        return DocumentPropertyValueDto.fromJsonSchema(
          schema,
          properties: properties,
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
    required DocumentPropertiesDto properties,
  }) {
    final values = properties.getProperty(schema.nodeId) as List? ?? [];
    final itemsSchema = schema.itemsSchema;

    return DocumentPropertyListDto(
      schema: schema,
      properties: [
        for (int i = 0; i < values.length; i++)
          DocumentPropertyDto.fromJsonSchema(
            itemsSchema.withNodeId(schema.nodeId.child('$i')),
            properties: properties,
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

    return DocumentListProperty(
      schema: schema,
      properties: mappedProperties,
      validationResult: schema.validate(mappedProperties),
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
    required DocumentPropertiesDto properties,
  }) {
    return DocumentPropertyObjectDto(
      schema: schema,
      properties: schema.properties.map((childSchema) {
        return DocumentPropertyDto.fromJsonSchema(
          childSchema,
          properties: properties,
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

    return DocumentObjectProperty(
      schema: schema,
      properties: mappedProperties,
      validationResult: schema.validate(mappedProperties),
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
    required DocumentPropertiesDto properties,
  }) {
    final property = properties.getProperty(schema.nodeId);

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
    return DocumentValueProperty<T>(
      schema: schema,
      value: value,
      validationResult: schema.validate(value),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        schema.id: value,
      };
}
