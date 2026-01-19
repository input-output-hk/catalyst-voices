import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_data_dto.g.dart';

/// Dto of [DocumentDataContent].
///
/// Contains utility structure for traversing a json map using [DocumentNodeId].
final class DocumentDataContentDto {
  final Map<String, dynamic> data;

  factory DocumentDataContentDto.fromDocument({
    required String schemaUrl,
    required Iterable<Map<String, dynamic>> properties,
  }) {
    return DocumentDataContentDto.fromJson({
      r'$schema': schemaUrl,
      for (final property in properties) ...property,
    });
  }

  const DocumentDataContentDto.fromJson(this.data);

  DocumentDataContentDto.fromModel(DocumentDataContent data) : data = data.data;

  String get schemaUrl => data[r'$schema'] as String;

  /// Retrieves the value of a property located at the specified [nodeId].
  ///
  /// This method traverses the nested structure of the [data] using
  /// the paths defined in the [nodeId]. If the specified path exists, the
  /// corresponding property value is returned. If the path is invalid or does
  /// not exist, the method returns `null`.
  Object? getProperty(DocumentNodeId nodeId) {
    return DocumentNodeTraverser.getValue(nodeId, data);
  }

  Map<String, dynamic> toJson() => data;

  DocumentDataContent toModel() => DocumentDataContent(data);
}

/// DTO of [DocumentData].
@JsonSerializable()
final class DocumentDataDto {
  final DocumentDataMetadataDto metadata;
  final DocumentDataContentDto content;

  const DocumentDataDto({
    required this.metadata,
    required this.content,
  });

  factory DocumentDataDto.fromJson(Map<String, dynamic> json) {
    return _$DocumentDataDtoFromJson(json);
  }

  factory DocumentDataDto.fromModel(DocumentData document) {
    return DocumentDataDto(
      metadata: DocumentDataMetadataDto.fromModel(document.metadata),
      content: DocumentDataContentDto.fromModel(document.content),
    );
  }

  Map<String, dynamic> toJson() => _$DocumentDataDtoToJson(this);

  DocumentData toModel() {
    return DocumentData(
      metadata: metadata.toModel(),
      content: content.toModel(),
    );
  }
}

@JsonSerializable()
final class DocumentDataMetadataDto {
  @JsonKey(
    toJson: DocumentContentType.toJson,
    fromJson: DocumentContentType.fromJson,
  )
  final DocumentContentType contentType;
  @JsonKey(
    toJson: DocumentType.toJson,
    fromJson: DocumentType.fromJson,
  )
  final DocumentType type;
  final DocumentRefDto id;
  final DocumentRefDto? ref;
  final DocumentRefDto? template;
  final DocumentRefDto? reply;
  final String? section;
  final List<String>? collaborators;
  final List<DocumentRefDto> parameters;
  final List<String>? authors;

  DocumentDataMetadataDto({
    required this.contentType,
    required this.type,
    required this.id,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.parameters = const [],
    this.authors,
  });

  factory DocumentDataMetadataDto.fromJson(Map<String, dynamic> json) {
    var migrated = migrateJson1(json);
    migrated = migrateJson2(migrated);
    migrated = migrateJson3(migrated);
    migrated = migrateJson4(migrated);
    migrated = migrateJson5(migrated);

    return _$DocumentDataMetadataDtoFromJson(migrated);
  }

  DocumentDataMetadataDto.fromModel(DocumentDataMetadata data)
    : this(
        contentType: data.contentType,
        type: data.type,
        id: data.id.toDto(),
        ref: data.ref?.toDto(),
        template: data.template?.toDto(),
        reply: data.reply?.toDto(),
        section: data.section,
        collaborators: data.collaborators?.map((e) => e.toString()).toList(),
        parameters: data.parameters.set.map((e) => e.toDto()).toList(),
        authors: data.authors?.map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson() => _$DocumentDataMetadataDtoToJson(this);

  DocumentDataMetadata toModel() {
    return DocumentDataMetadata(
      contentType: contentType,
      type: type,
      id: id.toModel(),
      ref: ref?.toModel(),
      template: template?.toModel().toSignedDocumentRef(),
      reply: reply?.toModel().toSignedDocumentRef(),
      section: section,
      collaborators: collaborators?.map((e) => CatalystId.fromUri(e.getUri())).toList(),
      parameters: DocumentParameters(
        parameters.map((e) => e.toModel().toSignedDocumentRef()).toSet(),
      ),
      authors: authors?.map(CatalystId.parse).toList(),
    );
  }

  @visibleForTesting
  static Map<String, dynamic> migrateJson1(Map<String, dynamic> json) {
    final needsMigration = json.containsKey('id') && json.containsKey('version');
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

    if (needsMigration) {
      final id = modified.remove('id') as String;
      final version = modified.remove('version') as String;

      modified['selfRef'] = {
        'id': id,
        'version': version,
        'type': DocumentRefDtoType.signed.name,
      };
    }

    return modified;
  }

  @visibleForTesting
  static Map<String, dynamic> migrateJson2(Map<String, dynamic> json) {
    final needsMigration = json['brandId'] is String || json['campaignId'] is String;
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

    if (modified['brandId'] is String) {
      final id = modified.remove('brandId') as String;
      final dto = DocumentRefDto(
        id: id,
        type: DocumentRefDtoType.signed,
      );
      modified['brandId'] = dto.toJson();
    }
    if (modified['campaignId'] is String) {
      final id = modified.remove('campaignId') as String;
      final dto = DocumentRefDto(
        id: id,
        type: DocumentRefDtoType.signed,
      );
      modified['campaignId'] = dto.toJson();
    }

    return modified;
  }

  /// v0.0.1 -> v0.0.4 spec: https://github.com/input-output-hk/catalyst-libs/pull/341/files#diff-2827956d681587dfd09dc733aca731165ff44812f8322792bf6c4a61cf2d3b85
  @visibleForTesting
  static Map<String, dynamic> migrateJson3(Map<String, dynamic> json) {
    final parametersKeys = ['brandId', 'campaignId', 'categoryId'];
    final needsMigration = parametersKeys.any(json.containsKey);
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);
    final parameters = <DocumentRefDto>[];

    for (final key in parametersKeys) {
      final value = modified.remove(key);
      if (value is Map<String, dynamic>) {
        parameters.add(DocumentRefDto.fromJson(value));
      }
    }

    modified['parameters'] = parameters.map((e) => e.toJson()).toList();
    return modified;
  }

  /// Adds missing contentType field.
  @visibleForTesting
  static Map<String, dynamic> migrateJson4(Map<String, dynamic> json) {
    final needsMigration = !json.containsKey('contentType');
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);
    final type = _tryParseDocumentType(json['type']);
    final contentType = type?.contentType ?? DocumentContentType.json;
    modified['contentType'] = DocumentContentType.toJson(contentType);
    return modified;
  }

  @visibleForTesting
  static Map<String, dynamic> migrateJson5(Map<String, dynamic> json) {
    final needsMigration = json.containsKey('selfRef');
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

    if (modified.containsKey('selfRef')) {
      modified['id'] = modified.remove('selfRef');
    }

    return modified;
  }

  static DocumentType? _tryParseDocumentType(Object? object) {
    if (object is String) {
      return DocumentType.fromJson(object);
    }

    return null;
  }
}

extension on DocumentRef {
  DocumentRefDto toDto() => DocumentRefDto.fromModel(this);
}
