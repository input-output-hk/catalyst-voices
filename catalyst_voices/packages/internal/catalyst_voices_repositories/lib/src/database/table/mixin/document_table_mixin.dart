import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:drift/drift.dart';

mixin DocumentTableMixin on Table {
  /// Refers to [DocumentType] uuid.
  TextColumn get type => text().map(DocumentConverters.type)();

  /// Encoded version of [DocumentData.content]
  ///
  /// Uses jsonb
  BlobColumn get content => blob().map(DocumentConverters.content)();

  /// Encoded version of [DocumentData.metadata]
  ///
  /// Uses jsonb
  BlobColumn get metadata => blob().map(DocumentConverters.metadata)();
}
