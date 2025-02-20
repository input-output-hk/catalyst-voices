import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as path;

class OpenApiPreProcessBuilder implements Builder {
  static const _inputFileExtensions = ['.json'];
  static const _stagingPath = 'openapi/processed';

  final String sourcepath;

  Map<String, List<String>>? _buildExtensions;

  OpenApiPreProcessBuilder(BuilderOptions options)
      : sourcepath = path.normalize(
          options.config['sourcepath'] as String? ?? 'temp',
        );

  @override
  Map<String, List<String>> get buildExtensions =>
      _buildExtensions ??= _generateExtensions(
        sourcepath,
        _stagingPath,
      );

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    if (!inputId.path.startsWith(sourcepath)) {
      return;
    }

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
        'File ${inputId.path} does not have "openapi": "3.0.0". Skipping.',
      );
      return;
    }

    final filteredJson = filterAllOf(jsonData);

    final outputContent = const JsonEncoder.withIndent('  ').convert(
      filteredJson,
    );

    final baseName = path.basenameWithoutExtension(
      path.basenameWithoutExtension(
        inputId.path,
      ),
    );

    final outputFileName = '$baseName.processed.json';
    final outputFilePath = path.join(_stagingPath, outputFileName);
    final outputId = AssetId(inputId.package, outputFilePath);

    await buildStep.writeAsString(outputId, outputContent);
    log.info('Processed ${inputId.path} and wrote output to $outputFilePath');
  }

  static dynamic filterAllOf(dynamic obj) {
    if (obj is List) {
      return obj.map(filterAllOf).toList();
    } else if (obj is Map) {
      if (obj.containsKey('allOf') && obj['allOf'] is List) {
        final allOfList = obj['allOf'] as List;
        if (allOfList.any((item) => item is Map && item.containsKey(r'$ref'))) {
          obj['allOf'] = allOfList
              .where((item) => item is Map && item.containsKey(r'$ref'))
              .toList();
          obj.remove('title');
        } else {
          obj['allOf'] = filterAllOf(obj['allOf']);
        }
      }
      return obj.map((k, v) => MapEntry(k, filterAllOf(v)));
    } else {
      return obj;
    }
  }

  static Map<String, List<String>> _generateExtensions(
    String inputPath,
    String outputPath,
  ) {
    final result = <String, List<String>>{};
    final normalizedInput = path.normalize(inputPath);
    final normalizedOutput = path.normalize(outputPath);
    final entities = Directory(normalizedInput).listSync();

    for (final entity in entities) {
      if (entity is File &&
          _inputFileExtensions.any(
            (ending) => entity.path.endsWith(
              ending,
            ),
          )) {
        final baseName = path.basenameWithoutExtension(
          path.basenameWithoutExtension(
            entity.path,
          ),
        );
        final fileName = '$baseName.processed.json';
        final key = path.normalize(entity.path);
        result[key] = [path.join(normalizedOutput, fileName)];
      }
    }
    return result;
  }
}
