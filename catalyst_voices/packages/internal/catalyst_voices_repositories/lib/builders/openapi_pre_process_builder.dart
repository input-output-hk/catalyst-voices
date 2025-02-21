// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

/// Configuration for the OpenAPI pre-processor builder
@immutable
class BuilderConfiguration {
  /// Path where source OpenAPI files are located
  final String sourcePath;

  /// Whether to validate schema during processing
  final bool validateSchema;

  /// Default OpenAPI version to support
  final String defaultVersion;

  /// Output directory for processed files
  final String outputPath;

  /// Creates a new builder configuration
  const BuilderConfiguration({
    required this.sourcePath,
    this.validateSchema = true,
    this.defaultVersion = '3.0.0',
    this.outputPath = 'openapi/processed',
  });

  /// Creates configuration from builder options
  factory BuilderConfiguration.fromOptions(BuilderOptions options) {
    final config = options.config;
    return BuilderConfiguration(
      sourcePath: _validateSourcePath(config['sourcepath']),
      validateSchema: config['validateSchema'] as bool? ?? true,
      defaultVersion: config['defaultVersion'] as String? ?? '3.0.0',
      outputPath: config['outputPath'] as String? ?? 'openapi/processed',
    );
  }

  static String _validateSourcePath(dynamic value) {
    if (value == null) {
      throw ArgumentError('sourcepath configuration is required');
    }
    if (value is! String) {
      throw ArgumentError('sourcepath must be a string');
    }
    return path.normalize(value);
  }
}

/// A builder that pre-processes OpenAPI specification files
class OpenApiPreProcessBuilder implements Builder {
  static final _log = Logger('OpenApiPreProcessBuilder');
  static const _inputFileExtensions = ['.json'];

  final BuilderConfiguration _config;
  final ProcessingMetrics _metrics;
  Map<String, List<String>>? _buildExtensions;

  /// Creates a new OpenAPI pre-processor builder
  OpenApiPreProcessBuilder(BuilderOptions options)
      : _config = BuilderConfiguration.fromOptions(options),
        _metrics = ProcessingMetrics();

  @override
  Map<String, List<String>> get buildExtensions =>
      _buildExtensions ??= _generateExtensions();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    if (!_isValidInput(inputId)) return;

    _metrics.startProcessing();

    try {
      final result = await _processFile(buildStep);
      if (result.isFailure) {
        _log.severe('Processing failed for ${inputId.path}: ${result.error}');
        _metrics.recordError();
        return;
      }

      await _writeOutput(buildStep, inputId, result.data!);
      _metrics.recordSuccess();
    } catch (e, stack) {
      _log.severe(
        'Unexpected error processing ${inputId.path}',
        e,
        stack,
      );
      _metrics.recordError();
    }
  }

  Map<String, List<String>> _generateExtensions() {
    final result = <String, List<String>>{};
    final directory = Directory(path.normalize(_config.sourcePath));

    if (!directory.existsSync()) {
      _log.warning('Input directory does not exist: ${_config.sourcePath}');
      return result;
    }

    final entities = directory.listSync();
    for (final entity in entities) {
      if (entity is File &&
          _inputFileExtensions.any((ext) => entity.path.endsWith(ext))) {
        final baseName = path.basenameWithoutExtension(entity.path);
        final fileName = '$baseName.processed.json';
        final key = path.normalize(entity.path);
        result[key] = [path.join(_config.outputPath, fileName)];
      }
    }

    return result;
  }

  bool _isValidInput(AssetId inputId) {
    if (!inputId.path.startsWith(_config.sourcePath)) {
      _log.fine('Skipping file outside sourcepath: ${inputId.path}');
      _metrics.recordSkipped();
      return false;
    }
    return true;
  }

  Future<ProcessingResult> _processFile(BuildStep buildStep) async {
    final content = await buildStep.readAsString(buildStep.inputId);

    try {
      final jsonData = json.decode(content) as Map<String, dynamic>;

      final version = jsonData['openapi']?.toString();
      if (version == null) {
        return const ProcessingResult.failure(
          'Missing OpenAPI version',
        );
      }

      if (version != _config.defaultVersion) {
        return ProcessingResult.failure(
          'Unsupported OpenAPI version: $version',
        );
      }

      final processed = OpenApiProcessor.filterAllOf(jsonData);
      return ProcessingResult.success(processed);
    } on FormatException catch (e) {
      return ProcessingResult.failure('Invalid JSON format: $e');
    }
  }

  Future<void> _writeOutput(
    BuildStep buildStep,
    AssetId inputId,
    Map<String, dynamic> data,
  ) async {
    final outputContent = const JsonEncoder.withIndent('  ').convert(data);

    final baseName = path.basenameWithoutExtension(inputId.path);
    final outputFileName = '$baseName.processed.json';
    final outputFilePath = path.join(_config.outputPath, outputFileName);
    final outputId = AssetId(inputId.package, outputFilePath);

    await buildStep.writeAsString(outputId, outputContent);
    _log.info('Processed ${inputId.path} -> $outputFilePath');
  }
}

/// Processor for OpenAPI specifications
class OpenApiProcessor {
  /// Filters and processes allOf nodes in OpenAPI specifications
  static Map<String, dynamic> filterAllOf(Map<String, dynamic> data) {
    final result = _FilterAllOfVisitor().visit(data);
    return result as Map<String, dynamic>;
  }
}

/// Metrics collected during processing
class ProcessingMetrics {
  /// Number of files successfully processed
  int filesProcessed = 0;

  /// Number of files skipped
  int filesSkipped = 0;

  /// Number of errors encountered
  int errorCount = 0;

  final _stopwatch = Stopwatch();

  /// Total time spent processing
  Duration get totalTime => _stopwatch.elapsed;

  /// Records an error
  void recordError() => errorCount++;

  /// Records a skipped file
  void recordSkipped() => filesSkipped++;

  /// Records a successful processing
  void recordSuccess() => filesProcessed++;

  /// Starts timing the processing
  void startProcessing() => _stopwatch.start();

  @override
  String toString() {
    return '''
    Files processed: $filesProcessed
    Files skipped: $filesSkipped
    Errors: $errorCount
    Total time: ${totalTime.inSeconds}s
    ''';
  }
}

/// Result of processing an OpenAPI file
@immutable
class ProcessingResult {
  /// Whether processing was successful
  final bool success;

  /// Error message if processing failed
  final String? error;

  /// Processed data if successful
  final Map<String, dynamic>? data;

  /// Creates a failure result
  const ProcessingResult.failure(this.error)
      : success = false,
        data = null;

  /// Creates a successful result
  const ProcessingResult.success(this.data)
      : success = true,
        error = null;

  /// Whether the processing failed
  bool get isFailure => !success;

  /// Whether the processing was successful
  bool get isSuccess => success;
}

class _FilterAllOfVisitor {
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
