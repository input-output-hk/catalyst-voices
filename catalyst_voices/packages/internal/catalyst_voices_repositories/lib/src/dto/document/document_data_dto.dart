import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_data_dto.g.dart';

/// Dto of [DocumentDataContent].
///
/// Contains utility structure for traversing a json map using [DocumentNodeId].
final class DocumentDataContentDto {
  final Map<String, dynamic> data;

  String get schemaUrl => data[r'$schema'] as String;

  const DocumentDataContentDto.fromJson(this.data);

  DocumentDataContentDto.fromModel(DocumentDataContent data) : data = data.data;

  factory DocumentDataContentDto.fromDocument({
    required String schemaUrl,
    required Iterable<Map<String, dynamic>> properties,
  }) {
    return DocumentDataContentDto.fromJson({
      r'$schema': schemaUrl,
      for (final property in properties) ...property,
    });
  }

  DocumentDataContent toModel() => DocumentDataContent(data);

  /// Retrieves the value of a property located at the specified [nodeId].
  ///
  /// This method traverses the nested structure of the [data] using
  /// the paths defined in the [nodeId]. If the specified path exists, the
  /// corresponding property value is returned. If the path is invalid or does
  /// not exist, the method returns `null`.
  Object? getProperty(DocumentNodeId nodeId) {
    Object? object = data;
    for (final path in nodeId.paths) {
      if (object is Map<String, dynamic>) {
        object = object[path];
      } else if (object is List) {
        final index = int.tryParse(path);
        if (index == null) {
          // index must be a number
          return null;
        }
        object = object[index];
      } else {
        return null;
      }
    }

    return object;
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
  final String? brandId;
  final String? campaignId;
  final String? electionId;
  final String? categoryId;

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

  DocumentDataMetadataDto.fromModel(DocumentDataMetadata data)
      : this(
          type: data.type,
          selfRef: data.selfRef.toDto(),
          ref: data.ref?.toDto(),
          refHash: data.refHash?.toDto(),
          template: data.template?.toDto(),
          brandId: data.brandId,
          campaignId: data.campaignId,
          electionId: data.electionId,
          categoryId: data.categoryId,
        );

  factory DocumentDataMetadataDto.fromJson(Map<String, dynamic> json) {
    final migrated = _migrateJson1(json);

    return _$DocumentDataMetadataDtoFromJson(migrated);
  }

  Map<String, dynamic> toJson() => _$DocumentDataMetadataDtoToJson(this);

  DocumentDataMetadata toModel() {
    return DocumentDataMetadata(
      type: type,
      selfRef: selfRef.toModel(),
      ref: ref?.toModel(),
      refHash: refHash?.toModel(),
      template: template?.toModel(),
      brandId: brandId,
      campaignId: campaignId,
      electionId: electionId,
      categoryId: categoryId,
    );
  }
}

Map<String, dynamic> _migrateJson1(Map<String, dynamic> json) {
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

extension _SignedDocumentRefExt on DocumentRef {
  DocumentRefDto toDto() => DocumentRefDto.fromModel(this);
}

extension _SecuredSignedDocumentRefExt on SecuredDocumentRef {
  SecuredDocumentRefDto toDto() {
    return SecuredDocumentRefDto.fromModel(this);
  }
}
