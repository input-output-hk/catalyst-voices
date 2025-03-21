import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
    toJson: DocumentType.toJson,
    fromJson: DocumentType.fromJson,
  )
  final DocumentType type;
  final DocumentRefDto selfRef;
  final DocumentRefDto? ref;
  final SecuredDocumentRefDto? refHash;
  final DocumentRefDto? template;
  final DocumentRefDto? brandId;
  final DocumentRefDto? campaignId;
  final String? electionId;
  final DocumentRefDto? categoryId;

  DocumentDataMetadataDto({
    required this.type,
    required this.selfRef,
    this.ref,
    this.refHash,
    this.template,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  });

  factory DocumentDataMetadataDto.fromJson(Map<String, dynamic> json) {
    var migrated = _migrateJson1(json);
    migrated = _migrateJson2(migrated);

    return _$DocumentDataMetadataDtoFromJson(migrated);
  }

  DocumentDataMetadataDto.fromModel(DocumentDataMetadata data)
      : this(
          type: data.type,
          selfRef: data.selfRef.toDto(),
          ref: data.ref?.toDto(),
          refHash: data.refHash?.toDto(),
          template: data.template?.toDto(),
          brandId: data.brandId?.toDto(),
          campaignId: data.campaignId?.toDto(),
          electionId: data.electionId,
          categoryId: data.categoryId?.toDto(),
        );

  Map<String, dynamic> toJson() => _$DocumentDataMetadataDtoToJson(this);

  DocumentDataMetadata toModel() {
    return DocumentDataMetadata(
      type: type,
      selfRef: selfRef.toModel(),
      ref: ref?.toModel(),
      refHash: refHash?.toModel(),
      template: template?.toModel().toSignedDocumentRef(),
      brandId: brandId?.toModel().toSignedDocumentRef(),
      campaignId: campaignId?.toModel().toSignedDocumentRef(),
      electionId: electionId,
      categoryId: categoryId?.toModel().toSignedDocumentRef(),
    );
  }

  static Map<String, dynamic> _migrateJson1(Map<String, dynamic> json) {
    final modified = Map<String, dynamic>.from(json);

    if (modified.containsKey('id') && modified.containsKey('version')) {
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

  static Map<String, dynamic> _migrateJson2(Map<String, dynamic> json) {
    final modified = Map<String, dynamic>.from(json);

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
}

extension on DocumentRef {
  DocumentRefDto toDto() => DocumentRefDto.fromModel(this);
}

extension on SecuredDocumentRef {
  SecuredDocumentRefDto toDto() {
    return SecuredDocumentRefDto.fromModel(this);
  }
}
