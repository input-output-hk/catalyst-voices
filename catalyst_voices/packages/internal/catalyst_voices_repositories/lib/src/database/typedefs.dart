import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.drift.dart';

/// Each document has list of metadata rows
typedef DocumentEntityWithMetadata = ({
  DocumentEntity document,
  List<DocumentMetadataEntity> metadata,
});
