import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:drift/drift.dart';

mixin DocumentTableMixin on Table {
  /// Refers to [SignedDocumentType] uuid.
  TextColumn get type => text()();

  // TODO(damian-molinski): check json1/jsonb support
  /// Encoded version of [SignedDocumentData.payload]
  TextColumn get content => text()();

  /// Encoded version of [SignedDocumentData.metadata]
  TextColumn get metadata => text()();
}
