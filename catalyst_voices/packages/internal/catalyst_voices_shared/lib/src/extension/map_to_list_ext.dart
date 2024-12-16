extension MapToListExt on Map<String, dynamic> {
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
}
