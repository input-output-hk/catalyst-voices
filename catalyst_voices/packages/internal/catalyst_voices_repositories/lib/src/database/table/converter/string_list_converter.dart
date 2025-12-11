import 'dart:convert';

import 'package:drift/drift.dart';

/// A [TypeConverter] that converts a [List] of nullable [String]s to a JSON string
/// for storage in a SQLite database, and parses it back when reading.
///
/// This handles:
/// - Encoding valid string lists to JSON arrays.
/// - Decoding JSON arrays back to string lists.
/// - Graceful handling of empty strings or invalid JSON by returning an empty list.
class StringListConverter extends TypeConverter<List<String?>, String> {
  const StringListConverter();

  @override
  List<String?> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return const [];
    }

    try {
      return (jsonDecode(fromDb) as List<dynamic>).cast<String?>().toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  String toSql(List<String?> value) {
    return jsonEncode(value);
  }
}
