extension DocumentMapToListExt on Map<String, dynamic> {
  List<Map<String, dynamic>> convertMapToListWithIds() {
    final list = <Map<String, dynamic>>[];

    for (final entry in entries) {
      if (entry.key == r'$schema') continue;
      final value = entry.value as Map<String, dynamic>;
      value['id'] = entry.key;
      list.add(value);
    }

    return list;
  }

  List<Map<String, dynamic>> convertMapToListWithIdsAndValues() {
    final list = <Map<String, dynamic>>[];

    for (final entry in entries) {
      if (entry.key == r'$schema') continue;
      final value = <String, dynamic>{};
      value['id'] = entry.key;
      value['value'] = entry.value;
      list.add(value);
    }

    return list;
  }
}
