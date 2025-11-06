import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import 'asset_version_manifest.dart';

class WebAssetVersioner {
  /// Hardcoded files that should be manually versioned
  /// (These are just for documentation/warning purposes)
  static const manuallyVersionedFiles = [
    'sqlite3.wasm',
    'drift_worker.js',
    'catalyst_key_derivation_bg.wasm',
    'catalyst_compression_bg.wasm',
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

    _log('Discovering manually versioned files...');
    await _discoverManuallyVersionedFiles();

    _log('\nCalculating MD5 hashes and renaming files...');
    await _calculateHashesAndRenameFiles();

    _log('\nUpdating asset references in HTML and JavaScript files...');
    await _updateAssetReferences();

    _log('\nFixing dynamic skwasm filename construction...');
    await _fixDynamicSkwasmReferences();

    _log('\nGenerating version manifest...');
    await _generateManifest();

    _log('\nVersioning summary:');
    _log('- Total files versioned: ${_versionMap.length}');

    final discoveredManual = manuallyVersionedFiles
        .where((file) => _versionMap.containsKey(file))
        .toList();
    final notFoundManual = manuallyVersionedFiles
        .where((file) => !_versionMap.containsKey(file))
        .toList();

    if (discoveredManual.isNotEmpty) {
      _log('- Manually versioned files discovered:');
      for (final file in discoveredManual) {
        _log('  ✓ $file -> ${_versionMap[file]}');
      }
    }

    if (notFoundManual.isNotEmpty) {
      _log('- Manually versioned files not found (may not be used):');
      for (final file in notFoundManual) {
        _log('  ⚠ $file');
      }
    }
  }

  Future<void> _calculateHashesAndRenameFiles() async {
    for (final filePath in autoVersionedFiles) {
      final file = File(path.join(buildDir, filePath));

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

  Future<void> _discoverManuallyVersionedFiles() async {
    for (final fileName in manuallyVersionedFiles) {
      final basename = path.basenameWithoutExtension(fileName);
      final ext = path.extension(fileName);

      final allFiles = await Directory(buildDir)
          .list(recursive: true)
          .where((entity) => entity is File)
          .cast<File>()
          .toList();

      final matchingFiles = allFiles.where((file) {
        final name = path.basename(file.path);
        final versionedPattern = RegExp(
          '^${RegExp.escape(basename)}\\.[a-f0-9]+${RegExp.escape(ext)}\$',
        );
        return name == fileName || versionedPattern.hasMatch(name);
      }).toList();

      if (matchingFiles.isEmpty) {
        _log('⚠ Manually versioned file not found: $fileName (skipping)');
        continue;
      }

      if (matchingFiles.length > 1) {
        _log(
          '⚠ Multiple matches for $fileName: ${matchingFiles.map((f) => path.basename(f.path)).join(", ")}',
        );
      }

      // Use the first match
      final matchedFile = matchingFiles.first;
      final matchedFileName = path.basename(matchedFile.path);

      // Only add to map if it's actually versioned (not the original filename)
      if (matchedFileName != fileName) {
        // Extract the hash from the filename
        final hashPattern = RegExp(
          r'^' +
              RegExp.escape(basename) +
              r'\.([a-f0-9]+)' +
              RegExp.escape(ext) +
              r'$',
        );
        final hashMatch = hashPattern.firstMatch(matchedFileName);
        final hash = hashMatch?.group(1) ?? '';

        _versionMap[fileName] = matchedFileName;
        _hashMap[fileName] = hash;
      }
    }
  }

  Future<void> _fixDynamicSkwasmReferences() async {
    final bootstrapEntry = _versionMap.entries.firstWhere(
      (entry) => entry.key == 'flutter_bootstrap.js',
    );
    final bootstrapFile = File(path.join(buildDir, bootstrapEntry.value));

    String content = await bootstrapFile.readAsString();

    final skwasmHash = _hashMap['canvaskit/skwasm.js'];
    final skwasmHeavyHash = _hashMap['canvaskit/skwasm_heavy.js'];

    if (skwasmHash == null || skwasmHeavyHash == null) {
      _log('Skwasm hashes not found, skipping dynamic replacement');
      return;
    }
    final pattern = RegExp(r'\?"skwasm_heavy":"skwasm"');
    final replacement = '?"skwasm_heavy.$skwasmHeavyHash":"skwasm.$skwasmHash"';

    if (content.contains(pattern)) {
      content = content.replaceAll(pattern, replacement);
      await bootstrapFile.writeAsString(content, flush: true);
    }
  }

  Future<void> _generateManifest() async {
    final manifestFile = File(path.join(buildDir, 'asset_versions.json'));

    final manifest = AssetVersionManifest(
      generated: DateTime.now().toUtc().toIso8601String(),
      versionedAssets: _versionMap,
      assetHashes: _hashMap,
      manuallyVersionedFiles: manuallyVersionedFiles.toList(),
    );

    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(manifest.toJson());

    await manifestFile.writeAsString('$jsonString\n', flush: true);
    _log('✓ Generated manifest: asset_versions.json');
  }

  void _log(String message) {
    if (verbose) {
      stdout.writeln(message);
    }
  }

  String _replacePathInContent(
    String content,
    String originalPath,
    String versionedPath,
  ) {
    final escaped = RegExp.escape(originalPath);
    return content
        .replaceAll(RegExp('"$escaped"'), '"$versionedPath"')
        .replaceAll(RegExp("'$escaped'"), "'$versionedPath'");
  }

  Future<void> _updateAssetReferences() async {
    final targetFiles = await Directory(buildDir)
        .list(recursive: true)
        .where(
          (entity) =>
              entity is File &&
              (entity.path.endsWith('.html') || entity.path.endsWith('.js')),
        )
        .cast<File>()
        .toList();

    for (final file in targetFiles) {
      bool fileModified = false;
      String content = await file.readAsString();

      for (final entry in _versionMap.entries) {
        final originalPath = entry.key;
        final versionedPath = entry.value;

        final updated = _replacePathInContent(
          content,
          originalPath,
          versionedPath,
        );
        if (updated != content) {
          content = updated;
          fileModified = true;
        }

        // Handle relative path suffixes for files in subdirectories
        if (originalPath.contains('/')) {
          final parts = path.split(originalPath);
          final versionedParts = path.split(versionedPath);

          for (var i = 1; i < parts.length; i++) {
            final suffix = path.joinAll(parts.sublist(i));
            final versionedSuffix = path.joinAll(versionedParts.sublist(i));

            final updated = _replacePathInContent(
              content,
              suffix,
              versionedSuffix,
            );
            if (updated != content) {
              content = updated;
              fileModified = true;
            }
          }
        }
      }

      if (fileModified) {
        await file.writeAsString(content, flush: true);
        _log('✓ Updated references in ${path.basename(file.path)}');
      }
    }
  }

  /// Versions a single file with its MD5 hash.
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
}
