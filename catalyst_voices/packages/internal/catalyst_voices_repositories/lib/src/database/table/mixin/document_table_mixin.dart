import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:drift/drift.dart';

mixin DocumentTableMixin on Table {
  /// Refers to [SignedDocumentType] uuid.
  TextColumn get type => text().map(DocumentConverters.type)();

  /// Encoded version of [SignedDocumentData.content]
  ///
  /// Uses jsonb
  BlobColumn get content => blob().map(DocumentConverters.content)();

  /// Encoded version of [SignedDocumentData.metadata]
  ///
  /// Uses jsonb
  BlobColumn get metadata => blob().map(DocumentConverters.metadata)();
}
