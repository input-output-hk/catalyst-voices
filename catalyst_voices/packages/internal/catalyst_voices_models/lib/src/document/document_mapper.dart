import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// An interface for the mapper of [Document].
abstract interface class DocumentMapper {
  Map<String, dynamic> metadataToMap(DocumentDataMetadata metadata);

  DocumentDataContent toContent(Document document);
}
