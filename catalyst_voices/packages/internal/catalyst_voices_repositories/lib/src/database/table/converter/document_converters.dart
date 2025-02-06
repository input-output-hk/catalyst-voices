import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/signed_document_data_dto.dart';
import 'package:drift/drift.dart';

typedef DocumentContentJsonBConverter
    = JsonTypeConverter2<SignedDocumentContent, Uint8List, Object?>;

typedef DocumentMetadataJsonBConverter
    = JsonTypeConverter2<SignedDocumentMetadata, Uint8List, Object?>;

abstract final class DocumentConverters {
  static final DocumentContentJsonBConverter content = TypeConverter.jsonb(
    fromJson: (json) => SignedDocumentContent(json! as Map<String, Object?>),
    toJson: (content) => content.data,
  );

  static final DocumentMetadataJsonBConverter metadata = TypeConverter.jsonb(
    fromJson: (json) =>
        SignedDocumentMetadataDto.fromJson(json! as Map<String, Object?>)
            .toModel(),
    toJson: (metadata) =>
        SignedDocumentMetadataDto.fromModel(metadata).toJson(),
  );
}
