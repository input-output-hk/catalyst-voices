import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import 'asset_version_manifest.dart';

class WebAssetVersioner2 {
  //version of these files should be: v1, v2, v3
  static const manuallyVersionedFiles = [
    'sqlite3.wasm',
    'drift_worker.js',
    'assets/packages/catalyst_key_derivation/assets/js/catalyst_key_derivation_bg.wasm',
    'assets/packages/catalyst_key_derivation/assets/js/catalyst_key_derivation.js',
    'assets/packages/catalyst_compression/assets/js/catalyst_compression_bg.wasm',
    'assets/packages/catalyst_compression/assets/js/catalyst_compression.js',
  ];

  final String buildDir;
  final bool verbose;
  final bool wasm;

  /// Maps original filename to versioned filename
  final Map<String, String> _versionMap = {};

  /// Maps original filename to hash
  final Map<String, String> _hashMap = {};

  WebAssetVersioner2({
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

    _generateAssetVersionFile();
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

  void _findManuallyVersionFiles() {
    for (final file in manuallyVersionedFiles) {
      final fullPath = path.join(buildDir, path.dirname(file));
      final basename = path.basenameWithoutExtension(file);
      final ext = path.extension(file);

      final directory = Directory(fullPath);
      if (!directory.existsSync()) {
        continue;
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
        continue;
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

  void _log(String message) {
    if (verbose) {
      stdout.writeln(message);
    }
  }

  Future<void> _updateAssetReferences() async {
    final targetFiles = await Directory(buildDir)
        .list(recursive: true)
        .where(
          (file) =>
              file is File &&
              (path.extension(file.path).contains('.html') ||
                  path.extension(file.path).contains('.js')),
        )
        .cast<File>()
        .toList();

    _log('Searching for asset references in ${targetFiles.length} files...');

    for (final file in targetFiles) {
      await _updateReferencesInFile(file);
    }
  }

  /// Updates asset references in a single file, properly handling relative paths
  Future<void> _updateReferencesInFile(File file) async {
    String content = await file.readAsString();
    bool wasModified = false;

    final fileDir = path.dirname(path.relative(file.path, from: buildDir));

    // For each versioned asset, try to find and replace references
    for (final entry in _versionMap.entries) {
      final originalPath = entry.key;
      final versionedPath = entry.value;
      final hash = _hashMap[originalPath];

      if (hash == null) continue;

      // Try to find references considering relative paths
      final originalFilename = path.basename(originalPath);
      final originalDir = path.dirname(originalPath);

      // Build list of possible reference patterns
      final patterns = <String>[];

      // Check if the versioned file is in the same directory as the current file
      if (originalDir == fileDir) {
        patterns.add(originalFilename);
      }

      // Add relative path from current file to versioned file
      final relativePath = path.relative(originalPath, from: fileDir);
      if (relativePath != originalFilename) {
        patterns.add(relativePath);
      }

      // Add path suffix patterns (for partial paths like "chromium/canvaskit.js")
      // This matches when the original path ends with a partial reference
      final parts = originalPath.split('/');
      for (int i = 1; i < parts.length; i++) {
        final suffix = parts.sublist(i).join('/');
        if (suffix != originalFilename && suffix != relativePath) {
          patterns.add(suffix);
        }
      }

      // Try each pattern
      for (final pattern in patterns) {
        final patternBasename = path.basenameWithoutExtension(pattern);
        final patternDir = path.dirname(pattern);
        final patternDirPrefix = patternDir == '.' ? '' : '$patternDir/';

        // Escape special regex characters
        final escapedPattern = RegExp.escape(pattern);
        final escapedBasename = RegExp.escape(patternBasename);

        // Pattern 1: Standard quoted strings "filename.ext" or 'filename.ext'
        final quotedRegex = RegExp(
          '(["\'])($escapedPattern)(["\'])',
          multiLine: true,
        );

        if (quotedRegex.hasMatch(content)) {
          final versionedFilename = path.basename(versionedPath);
          final replacement = patternDir == '.'
              ? versionedFilename
              : '$patternDirPrefix$versionedFilename';

          content = content.replaceAllMapped(
            quotedRegex,
            (match) => '${match.group(1)}$replacement${match.group(3)}',
          );
          wasModified = true;

          _log(
            '  Updated reference in ${path.relative(file.path, from: buildDir)}: '
            '$pattern -> $replacement',
          );
        }

        // Pattern 2: Ternary operators - match basename with or without extension
        // e.g., ?"skwasm_heavy":"skwasm" -> ?"skwasm_heavy.HASH":"skwasm.HASH"
        // or   ?"canvaskit.js":"skwasm.js" -> ?"canvaskit.HASH.js":"skwasm.HASH.js"
        final ternaryRegex = RegExp(
          '(["\'])($escapedBasename(?:\\.[a-zA-Z0-9]+)?)(["\'])',
          multiLine: true,
        );

        content = content.replaceAllMapped(ternaryRegex, (match) {
          final matchedString = match.group(2)!;

          // Skip if already versioned (contains 8-char hash pattern)
          if (RegExp(r'\.[0-9a-f]{8}(?:\.|$)').hasMatch(matchedString)) {
            return match.group(0)!;
          }

          // Extract basename and extension from the matched string
          final matchedBasename = path.basenameWithoutExtension(matchedString);
          final matchedExt = path.extension(matchedString);

          // Check if this basename matches our versioned file
          if (matchedBasename == patternBasename) {
            // Skip if hash is empty (e.g., manually versioned files without hash)
            if (hash.isEmpty) {
              return match.group(0)!;
            }

            // Build the versioned filename: basename.hash[.ext if present]
            final versionedString = matchedExt.isEmpty
                ? '$patternBasename.$hash'
                : '$patternBasename.$hash$matchedExt';
            wasModified = true;

            _log(
              '  Updated ternary reference in ${path.relative(file.path, from: buildDir)}: '
              '$matchedString -> $versionedString',
            );

            return '${match.group(1)}$versionedString${match.group(3)}';
          }

          return match.group(0)!;
        });
      }
    }

    if (wasModified) {
      await file.writeAsString(content);
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
