import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:drift/drift.dart';

/// Stores the raw binary of a signed document.
///
/// This is vertically partitioned from [DocumentsV2] to keep the main table
/// lean for high-performance listing and filtering queries.
@DataClassName('DocumentArtifactEntity')
class DocumentArtifacts extends Table {
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (id, ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];

  /// The raw binary representation of the signed document (e.g., CoseSign).
  BlobColumn get data => blob()();

  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id, ver};

  TextColumn get ver => text()();
}
