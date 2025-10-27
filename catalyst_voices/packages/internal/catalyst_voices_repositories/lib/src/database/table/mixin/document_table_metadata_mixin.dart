import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:drift/drift.dart';

mixin DocumentTableMetadataMixin on Table {
  TextColumn get authors => text()();

  TextColumn get categoryId => text().nullable()();

  TextColumn get categoryVer => text().nullable()();

  TextColumn get id => text()();

  TextColumn get refId => text().nullable()();

  TextColumn get refVer => text().nullable()();

  TextColumn get replyId => text().nullable()();

  TextColumn get replyVer => text().nullable()();

  TextColumn get section => text().nullable()();

  TextColumn get templateId => text().nullable()();

  TextColumn get templateVer => text().nullable()();

  TextColumn get type => text().map(DocumentConverters.type)();

  TextColumn get ver => text()();
}
