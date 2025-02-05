import 'package:drift/drift.dart';

// TODO(damian-molinski): use mixins for ids
class Documents extends Table {
  Int64Column get idHi => int64()();

  Int64Column get idLo => int64()();

  Int64Column get verHi => int64()();

  Int64Column get verLo => int64()();

  @override
  Set<Column<Object>>? get primaryKey => {
        idHi,
        idLo,
        verHi,
        verLo,
      };
}
