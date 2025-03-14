// lib/src/openapi_builder_base.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;

dynamic filterAllOf(dynamic obj) {
  if (obj is List) {
    return obj.map(filterAllOf).toList();
  } else if (obj is Map<String, dynamic>) {
    if (obj.containsKey('allOf') && obj['allOf'] is List) {
      List<dynamic> allOfList = obj['allOf'];

      // Check if any item in the list is a Map with a '$ref' key.
      bool hasRef = allOfList.any(
          (item) => item is Map<String, dynamic> && item.containsKey(r'$ref'));

      if (hasRef) {
        // Filter the list so that only items with '$ref' remain.
        obj['allOf'] = allOfList
            .where((item) =>
                item is Map<String, dynamic> && item.containsKey(r'$ref'))
            .toList();
        // Remove the "title" key if it exists.
        obj.remove('title');
      } else {
        // Otherwise, recursively filter the allOf list.
        obj['allOf'] = filterAllOf(allOfList);
      }
    }

    obj.forEach((key, value) {
      obj[key] = filterAllOf(value);
    });

    return obj;
  } else {
    return obj;
  }
}

const _inputFileExtensions = ['.json'];
Map<String, List<String>> _generateExtensions(
  String inputPath,
  String outputPath,
) {
  final result = <String, List<String>>{};
  final normalizedInput = p.normalize(inputPath);
  final normalizedOutput = p.normalize(outputPath);

  final entities = Directory(normalizedInput).listSync();
  for (final entity in entities) {
    if (entity is File &&
        _inputFileExtensions.any((ending) => entity.path.endsWith(ending))) {
      final baseName =
          p.basenameWithoutExtension(p.basenameWithoutExtension(entity.path));
      final fileName = '$baseName.json';
      final key = p.normalize(entity.path);
      result[key] = [p.join(normalizedOutput, fileName)];
    }
  }
  return result;
}

const _stagingpath = 'staging_folder/';

class Sanitise implements Builder {
  final String sourcepath;

  Sanitise(BuilderOptions options)
      : sourcepath = p.normalize(
            options.config['sourcepath'] as String? ?? 'source_folder/');

  @override
  Map<String, List<String>> get buildExtensions =>
      _buildExtensions ??= _generateExtensions(sourcepath, _stagingpath);

  Map<String, List<String>>? _buildExtensions;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    if (!inputId.path.startsWith(sourcepath)) {
      return;
    }

    // Read the contents of the JSON file.
    final content = await buildStep.readAsString(inputId);

    Map<String, dynamic> jsonData;
    try {
      jsonData = json.decode(content) as Map<String, dynamic>;
    } catch (e) {
      log.severe('Failed to parse JSON in ${inputId.path}: $e');
      return;
    }

    if (jsonData['openapi'] != '3.0.0') {
      log.info(
          'File ${inputId.path} does not have "openapi": "3.0.0". Skipping.');
      return;
    }

    final filteredJson = filterAllOf(jsonData);

    final outputContent =
        const JsonEncoder.withIndent('  ').convert(filteredJson);

    final baseName =
        p.basenameWithoutExtension(p.basenameWithoutExtension(inputId.path));
    final outputFileName = '$baseName.json';

    final outputFilePath = p.join(_stagingpath, outputFileName);

    final outputId = AssetId(inputId.package, outputFilePath);

    await buildStep.writeAsString(outputId, outputContent);
    log.info('Processed ${inputId.path} and wrote output to $outputFilePath');
  }
}

Builder sanitiseBuilderFactory(BuilderOptions options) {
  return Sanitise(options);
}
