import 'package:drift/drift.dart';
import 'package:drift/native.dart';

Future<QueryExecutor> buildExecutor() => Future.value(NativeDatabase.memory());
