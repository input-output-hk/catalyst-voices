import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:drift/drift.dart';

mixin DocumentTableContentMixin on Table {
  BlobColumn get content => blob().map(DocumentConverters.content)();
}
