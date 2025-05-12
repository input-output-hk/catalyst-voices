// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

/// Adapts OpenAPI specs produced by backend to something that code
/// generators can work with.
///
/// For example this bug:
/// - https://github.com/epam-cross-platform-lab/swagger-dart-code-generator/issues/721
void main() {
  // Ensure the processed directory exists
  final sourceDir = Directory('openapi');
  final processedDir = Directory('openapi/processed');
  if (!processedDir.existsSync()) {
    processedDir.createSync(recursive: true);
  }

  final oldProcessedFiles = processedDir
      .listSync()
      .whereType<File>()
      .where((element) => element.path.endsWith('.json'));

  // Delete any .json files from processedDir
  for (final file in oldProcessedFiles) {
    file.deleteSync();
  }

  final sourceFiles = sourceDir
      .listSync()
      .whereType<File>()
      .where((element) => element.path.endsWith('.json'));

  // Decode each source file, process and save processed version.
  for (final source in sourceFiles) {
    final baseName = path.basenameWithoutExtension(source.path);

    final json = source.readAsStringSync();
    final decodedJson = jsonDecode(json) as Map<String, dynamic>;

    final version = decodedJson['openapi']?.toString();
    if (version == null) {
      print('[$baseName] Missing OpenAPI version');
      continue;
    }

    if (!_supportedOpenApiVersions.contains(version)) {
      print('[$baseName] Unsupported OpenApi version[$version]');
      continue;
    }

    final processedJson = OpenApiProcessor.filterAllOf(
      decodedJson,
      source: baseName,
    );
    final encodedProcessedJson = jsonEncode(processedJson);

    final fileName = '$baseName.json';
    final filePath = path.join(processedDir.path, fileName);

    File(filePath)
      ..createSync()
      ..writeAsStringSync(encodedProcessedJson);

    print('Processed [$baseName] --> [$fileName]');
  }
}

const _supportedOpenApiVersions = ['3.0.0', '3.1.0'];

/// Processor for OpenAPI specifications
class OpenApiProcessor {
  /// Filters and processes allOf nodes in OpenAPI specifications
  static Map<String, dynamic> filterAllOf(
    Map<String, dynamic> data, {
    required String source,
  }) {
    final visitor = _FilterAllOfVisitor(source: source);
    final result = visitor.visit(data);
    return result as Map<String, dynamic>;
  }
}

class _FilterAllOfVisitor {
  final String source;
  final bool verbose;

  _FilterAllOfVisitor({
    required this.source,
    this.verbose = false,
  });

  dynamic visit(dynamic value) {
    if (value == null) return null;

    if (value is List) return _visitList(value);
    if (value is Map) return _visitMap(value as Map<String, dynamic>);
    return value;
  }

  bool _isAllOfNode(Map<String, dynamic> map) {
    return map.containsKey('allOf') && map['allOf'] is List;
  }

  bool _isRefNode(dynamic node) {
    return node is Map && node.containsKey(r'$ref');
  }

  Map<String, dynamic> _processAllOfNode(Map<String, dynamic> map) {
    final allOfList = map['allOf'] as List;
    final hasRefs = allOfList.any(_isRefNode);

    if (hasRefs) {
      // https://github.com/epam-cross-platform-lab/swagger-dart-code-generator/issues/721
      if (verbose) {
        print(
          '[$source] Found allOf and title. '
          'Removing title[${map['title']}]',
        );
      }

      return {
        ...map,
        'allOf': allOfList.where(_isRefNode).toList(),
      }..remove('title');
    }

    return {
      ...map,
      'allOf': visit(allOfList),
    };
  }

  List<dynamic> _visitList(List<dynamic> list) {
    return list.map(visit).toList();
  }

  Map<String, dynamic> _visitMap(Map<String, dynamic> map) {
    if (_isAllOfNode(map)) {
      return _processAllOfNode(map);
    }
    return map.map((key, value) => MapEntry(key, visit(value)));
  }
}
