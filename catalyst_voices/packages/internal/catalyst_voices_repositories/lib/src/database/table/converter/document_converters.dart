import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:drift/drift.dart';

typedef DocumentContentJsonBConverter = JsonTypeConverter2<DocumentDataContent, Uint8List, Object?>;

abstract final class DocumentConverters {
  /// Converts [DocumentType] to String for text column.
  static const TypeConverter<DocumentType, String> type = _DocumentTypeConverter();

  /// Converts [DocumentDataContent] into json for bloc column.
  /// Required for jsonb queries.
  static final DocumentContentJsonBConverter content = TypeConverter.jsonb(
    fromJson: (json) => DocumentDataContent(json! as Map<String, Object?>),
    toJson: (content) => content.data,
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
