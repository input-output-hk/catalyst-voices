import 'dart:convert';
import 'dart:io';

final class FixtureReader {
  FixtureReader._();

  static Future<String> read(String path) {
    final dir = Directory.current;
    final file = File('${dir.path}/test/fixture/$path');
    return file.readAsString();
  }

  static Future<Map<String, dynamic>> readJson(String filename) {
    return read('$filename.json')
        .then(jsonDecode)
        .then((value) => value as Map<String, dynamic>);
  }
}
