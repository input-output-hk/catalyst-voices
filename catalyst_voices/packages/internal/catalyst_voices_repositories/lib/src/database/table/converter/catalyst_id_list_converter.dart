import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:drift/drift.dart';

/// Converts a [List<CatalystId>] to a JSON string and back.
///
/// Stored format: `["id.catalyst://...", "id.catalyst://..."]`
class CatalystIdListConverter extends TypeConverter<List<CatalystId>, String> {
  const CatalystIdListConverter();

  @override
  List<CatalystId> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];

    final jsonList = jsonDecode(fromDb);
    if (jsonList is! List<dynamic>) {
      return const [];
    }

    return jsonList.cast<String>().map(CatalystId.tryParse).nonNulls.toList();
  }

  @override
  String toSql(List<CatalystId> value) {
    // optimize for empty list
    if (value.isEmpty) return '[]';

    final uriStrings = value.map((e) => e.toString()).toList();
    return jsonEncode(uriStrings);
  }
}
