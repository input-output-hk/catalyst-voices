import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:drift/drift.dart';

typedef DocumentContentJsonBConverter
    = JsonTypeConverter2<DocumentDataContent, Uint8List, Object?>;

typedef DocumentMetadataJsonBConverter
    = JsonTypeConverter2<DocumentDataMetadata, Uint8List, Object?>;

abstract final class DocumentConverters {
  /// Converts [DocumentType] to String for text column.
  static const TypeConverter<DocumentType, String> type =
      _DocumentTypeConverter();

  /// Converts [DocumentDataContent] into json for bloc column.
  /// Required for jsonb queries.
  static final DocumentContentJsonBConverter content = TypeConverter.jsonb(
    fromJson: (json) => DocumentDataContent(json! as Map<String, Object?>),
    toJson: (content) => content.data,
  );

  /// Converts [DocumentDataMetadata] into json for bloc column.
  /// Required for jsonb queries.
  static final DocumentMetadataJsonBConverter metadata = TypeConverter.jsonb(
    fromJson: (json) =>
        DocumentDataMetadataDto.fromJson(json! as Map<String, Object?>)
            .toModel(),
    toJson: (metadata) => DocumentDataMetadataDto.fromModel(metadata).toJson(),
  );
}

final class _DocumentTypeConverter extends TypeConverter<DocumentType, String> {
  const _DocumentTypeConverter();

  @override
  DocumentType fromSql(String fromDb) {
    return DocumentType.fromJson(fromDb);
  }

  @override
  String toSql(DocumentType value) {
    return DocumentType.toJson(value);
  }
}
