import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import 'asset_version_manifest.dart';
import 'ref_updater.dart';

class WebAssetVersioner {
  //version of these files should be: v1, v2, v3
  static const manuallyVersionedFiles = [
    'sqlite3.wasm',
    'drift_worker.js',
    'assets/packages/catalyst_key_derivation/assets/js/*/catalyst_key_derivation_bg.wasm',
    'assets/packages/catalyst_key_derivation/assets/js/*/catalyst_key_derivation.js',
    'assets/packages/catalyst_compression/assets/js/*/catalyst_compression_bg.wasm',
    'assets/packages/catalyst_compression/assets/js/*/catalyst_compression.js',
  ];

  final String buildDir;
  final bool verbose;
  final bool wasm;

  /// Maps original filename to versioned filename
  final Map<String, String> _versionMap = {};

  /// Maps original filename to hash
  final Map<String, String> _hashMap = {};

  WebAssetVersioner({
    required this.buildDir,
    this.verbose = true,
    required this.wasm,
  });

  /// Files that will be automatically versioned with content-based MD5 hashes
  List<String> get autoVersionedFiles => [
    'flutter_bootstrap.js',
    'main.dart.js',
    if (wasm) 'main.dart.wasm',
    if (wasm) 'main.dart.mjs',
    'canvaskit/canvaskit.wasm',
    'canvaskit/canvaskit.js',
    'canvaskit/canvaskit.js.symbols',
    'canvaskit/skwasm_heavy.wasm', //cspell:disable-line
    'canvaskit/skwasm_heavy.js', //cspell:disable-line
    'canvaskit/skwasm_heavy.js.symbols', //cspell:disable-line
    'canvaskit/skwasm.wasm', //cspell:disable-line
    'canvaskit/skwasm.js', //cspell:disable-line
    'canvaskit/skwasm.js.symbols', //cspell:disable-line
    'canvaskit/chromium/canvaskit.wasm',
    'canvaskit/chromium/canvaskit.js',
    'canvaskit/chromium/canvaskit.js.symbols',
  ];

  Future<void> versionAssets() async {
    _log('Starting web asset versioning...');
    _log('Build directory: $buildDir\n');

    final buildDirectory = Directory(buildDir);
    if (!buildDirectory.existsSync()) {
      throw Exception('Build directory not found: $buildDir');
    }

    _log('Find manually versioned files...');
    _findManuallyVersionFiles();

    _log('Calculating MD5 hashes and rename files...');
    await _calculateHashesAndRenameFiles();

    _log('\nUpdating asset references in HTML and JavaScript files...');
    await _updateAssetReferences();

    _log('\nGenerating Asset Version File...');
    _generateAssetVersionFile();

    _log('\nGenerating Caddyfile Snippet');
    _generateCaddyfileSnippet();
  }

  Future<void> _calculateHashesAndRenameFiles() async {
    for (final filePath in autoVersionedFiles) {
      final file = File(path.join(buildDir, filePath));

      // Skip symbol files as they need have same hash as they "parent"
      if (path.extension(filePath) == '.symbols') {
        continue;
      }

      if (!file.existsSync()) {
        throw Exception(
          'Required file not found: $filePath\n'
          'This file is expected to exist after flutter build web. '
          'If this file has been removed or renamed in Flutter, '
          'update the autoVersionedFiles list in web_asset_versioner.dart',
        );
      }

      await _versionFile(file, filePath);

      if (filePath.endsWith('.js')) {
        await _versionPartFiles(filePath);
      }

      // Find all symbols files and add same hash as their parent
      await _versionSymbolFiles(filePath);
    }
  }

  /// Creates a versioned filename by inserting the hash before the extension.
  /// Example: 'flutter_bootstrap.js' -> 'flutter_bootstrap.abc123.js'
  String _createVersionedFilename(String filename, String hash) {
    final dir = path.dirname(filename);
    final basename = path.basenameWithoutExtension(filename);
    final ext = path.extension(filename);
    final versioned = '$basename.$hash$ext';
    return dir == '.' ? versioned : path.join(dir, versioned);
  }

  void _findManuallyVersionFile(String file) {
    final fullPath = path.join(buildDir, path.dirname(file));
    final basename = path.basenameWithoutExtension(file);
    final ext = path.extension(file);

    final directory = Directory(fullPath);
    if (!directory.existsSync()) {
      return;
    }

    final versionedPattern = RegExp(
      '^${RegExp.escape(basename)}(?:\\.v(\\d+))?${RegExp.escape(ext)}\$',
    );

    final versionedFiles = directory
        .listSync()
        .whereType<File>()
        .where((file) => versionedPattern.hasMatch(path.basename(file.path)))
        .toList();

    if (versionedFiles.isEmpty) {
      return;
    }

    //Find out what version is assigned to this file
    final versionedFile = versionedFiles.first;
    final versionedFileName = path.basename(versionedFile.path);

    final hashMatch = versionedPattern.firstMatch(versionedFileName);
    final hash = hashMatch?.group(1) ?? '';

    final relativePath = path.relative(versionedFile.path, from: buildDir);
    _versionMap[file] = relativePath;
    _hashMap[file] = hash;
  }

  void _findManuallyVersionFiles() {
    for (final file in manuallyVersionedFiles) {
      if (file.contains('*')) {
        _findManuallyVersionFilesWithWildcard(file);
      } else {
        _findManuallyVersionFile(file);
      }
    }
  }

  void _findManuallyVersionFilesWithWildcard(String pattern) {
    final parts = pattern.split('/');
    final wildcardIndex = parts.indexWhere((part) => part.contains('*'));

    if (wildcardIndex == -1) {
      return;
    }

    final basePath = path.joinAll(parts.sublist(0, wildcardIndex));

    final fullBasePath = path.join(buildDir, basePath);

    final baseDirectory = Directory(fullBasePath);
    if (!baseDirectory.existsSync()) {
      return;
    }

    final wildcardPart = parts[wildcardIndex];
    final wildcardRegex = RegExp('^${wildcardPart.replaceAll('*', '.*')}\$');

    // Find all directories matching the wildcard
    final matchingDirs = baseDirectory
        .listSync()
        .whereType<Directory>()
        .where((dir) => wildcardRegex.hasMatch(path.basename(dir.path)))
        .toList();

    for (final dir in matchingDirs) {
      final actualDirName = path.basename(dir.path);
      final remainingParts = parts.sublist(wildcardIndex + 1);

      final filePath = path.joinAll([dir.path, ...remainingParts]);
      final file = File(filePath);

      if (!file.existsSync()) {
        continue;
      }

      // Extract version from directory name (e.g., v1, v2, v3)
      final versionMatch = RegExp(r'v(\d+)').firstMatch(actualDirName);
      final hash = versionMatch?.group(1) ?? '';

      final relativePath = path.relative(file.path, from: buildDir);

      // Build the actual pattern (original pattern with * replaced)
      final actualPattern = parts
          .asMap()
          .entries
          .map(
            (entry) => entry.key == wildcardIndex ? actualDirName : entry.value,
          )
          .join('/');

      _versionMap[actualPattern] = relativePath;
      _hashMap[actualPattern] = hash;

      _log('✓ Found $pattern -> $relativePath (matched: $actualDirName)');

      // Only map the first match
      break;
    }
  }

  Future<void> _generateAssetVersionFile() async {
    final assetVersionsFile = File(path.join(buildDir, 'asset_version.json'));

    final assetVersion = AssetVersionManifest(
      generated: DateTime.now().toUtc().toIso8601String(),
      versionedAssets: _versionMap,
      assetHashes: _hashMap,
      manuallyVersionedFiles: manuallyVersionedFiles,
    );

    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(assetVersion.toJson());

    await assetVersionsFile.writeAsString('$jsonString\n', flush: true);
    _log('Generated asset version file');
  }

  Future<void> _generateCaddyfileSnippet() async {
    final snippetFile = File(path.join(buildDir, 'versioned_assets.caddy'));

    final buffer = StringBuffer();
    buffer.writeln('# Auto-generated by version_web_assets.dart');
    buffer.writeln('# DO NOT EDIT: This file is regenerated on each build');
    buffer.writeln('# Generated: ${DateTime.now().toUtc().toIso8601String()}');
    buffer.writeln();
    buffer.writeln(
      '# Versioned assets (with content hashes) can be cached indefinitely',
    );
    buffer.writeln('@versioned_assets {');

    // Add path matchers for auto-versioned files
    for (final versionedPath in _versionMap.values) {
      buffer.writeln('    path /$versionedPath');
    }
    buffer.writeln('}');
    buffer.writeln(
      'header @versioned_assets Cache-Control "public, max-age=31536000, immutable"',
    );

    await snippetFile.writeAsString(buffer.toString(), flush: true);
    _log('✓ Generated Caddyfile snippet: versioned_assets.caddy');
  }

  void _log(String message) {
    if (verbose) {
      stdout.writeln(message);
    }
  }

  Future<void> _updateAssetReferences() async {
    final allFiles = await Directory(buildDir)
        .list(recursive: true)
        .where(
          (file) =>
              file is File &&
              (path.extension(file.path).contains('.html') ||
                  path.extension(file.path) == '.js'),
        )
        .cast<File>()
        .toList();

    final assetsBasename = _versionMap.keys
        .map((key) => path.basename(key))
        .toSet();

    // Filter files to only those that contain references to versioned assets
    final targetFiles = <File>[];
    for (final file in allFiles) {
      final content = await file.readAsString();

      final containsAssetReference = assetsBasename.any(
        (basename) => content.contains(basename),
      );

      if (containsAssetReference) {
        targetFiles.add(file);
      }
    }

    final updateRefRegistry = RefUpdaterRegistry();

    for (final file in targetFiles) {
      updateRefRegistry.updateFileReferences(
        file: file,
        versionMap: _versionMap,
      );
    }
  }

  Future<void> _versionFile(File file, String filePath) async {
    final bytes = await file.readAsBytes();
    final hash = md5.convert(bytes).toString();
    final shortHash = hash.substring(0, 8);

    final versionedFilename = _createVersionedFilename(filePath, shortHash);
    final versionedFile = File(path.join(buildDir, versionedFilename));

    await file.rename(versionedFile.path);

    // Store mapping: original -> versioned
    _versionMap[filePath] = versionedFilename;
    _hashMap[filePath] = shortHash;

    _log('✓ $filePath -> $versionedFilename');
  }

  Future<void> _versionPartFiles(String originalFilePath) async {
    final fileDir = path.dirname(path.join(buildDir, originalFilePath));
    final baseFileName = path.basename(originalFilePath);

    final partPattern = RegExp(
      '^${RegExp.escape(baseFileName)}_\\d+\\.part\\.js\$',
    );

    final directory = Directory(fileDir);
    if (!directory.existsSync()) return;

    final partFiles = directory
        .listSync()
        .whereType<File>()
        .where((file) => partPattern.hasMatch(path.basename(file.path)))
        .toList();

    for (final partFile in partFiles) {
      final partFileName = path.basename(partFile.path);

      final originalDir = path.dirname(originalFilePath);
      final relativePath = originalDir.isNotEmpty && originalDir != '.'
          ? path.join(originalDir, partFileName)
          : partFileName;

      await _versionFile(partFile, relativePath);
    }
  }

  Future<void> _versionSymbolFiles(String parentFilePath) async {
    final symbolFilePath = '$parentFilePath.symbols';
    final symbolFile = File(path.join(buildDir, symbolFilePath));

    if (!symbolFile.existsSync()) {
      return;
    }

    final parentHash = _hashMap[parentFilePath];
    if (parentHash == null) {
      _log('Warning: No hash found for parent file: $parentFilePath');
      return;
    }

    final versionedFilename = _createVersionedFilename(
      symbolFilePath,
      parentHash,
    );
    final versionedFile = File(path.join(buildDir, versionedFilename));

    await symbolFile.rename(versionedFile.path);

    _versionMap[symbolFilePath] = versionedFilename;
    _hashMap[symbolFilePath] = parentHash;

    _log('✓ $symbolFilePath -> $versionedFilename (using parent hash)');
  }
}
