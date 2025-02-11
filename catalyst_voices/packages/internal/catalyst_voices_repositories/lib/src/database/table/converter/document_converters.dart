import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/signed_document_data_dto.dart';
import 'package:drift/drift.dart';

typedef DocumentContentJsonBConverter
    = JsonTypeConverter2<SignedDocumentContent, Uint8List, Object?>;

typedef DocumentMetadataJsonBConverter
    = JsonTypeConverter2<SignedDocumentMetadata, Uint8List, Object?>;

abstract final class DocumentConverters {
  /// Converts [SignedDocumentType] to String for text column.
  static const TypeConverter<SignedDocumentType, String> type =
      _DocumentTypeConverter();

  /// Converts [SignedDocumentContent] into json for bloc column.
  /// Required for jsonb queries.
  static final DocumentContentJsonBConverter content = TypeConverter.jsonb(
    fromJson: (json) => SignedDocumentContent(json! as Map<String, Object?>),
    toJson: (content) => content.data,
  );

  /// Converts [SignedDocumentMetadata] into json for bloc column.
  /// Required for jsonb queries.
  static final DocumentMetadataJsonBConverter metadata = TypeConverter.jsonb(
    fromJson: (json) =>
        SignedDocumentMetadataDto.fromJson(json! as Map<String, Object?>)
            .toModel(),
    toJson: (metadata) =>
        SignedDocumentMetadataDto.fromModel(metadata).toJson(),
  );
}

final class _DocumentTypeConverter
    extends TypeConverter<SignedDocumentType, String> {
  const _DocumentTypeConverter();

  @override
  SignedDocumentType fromSql(String fromDb) {
    return SignedDocumentType.fromJson(fromDb);
  }

  @override
  String toSql(SignedDocumentType value) {
    return SignedDocumentType.toJson(value);
  }
}
