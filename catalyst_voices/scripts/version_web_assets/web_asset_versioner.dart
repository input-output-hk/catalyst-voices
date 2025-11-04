import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import 'asset_version_manifest.dart';

class WebAssetVersioner {
  /// Files that will be automatically versioned with content-based MD5 hashes
  static const autoVersionedFiles = [
    'flutter_bootstrap.js',
    'main.dart.js',
    'main.dart.wasm',
    'canvaskit/canvaskit.wasm',
    'canvaskit/skwasm_heavy.wasm',
    'canvaskit/skwasm.wasm',
    'canvaskit/chromium/canvaskit.wasm',
  ];

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

  /// Maps original filename to versioned filename
  final Map<String, String> _versionMap = {};

  /// Maps original filename to hash
  final Map<String, String> _hashMap = {};

  WebAssetVersioner({required this.buildDir, this.verbose = true});

  Future<void> versionAssets() async {
    _log('Starting web asset versioning...');
    _log('Build directory: $buildDir\n');

    final buildDirectory = Directory(buildDir);
    if (!buildDirectory.existsSync()) {
      throw Exception('Build directory not found: $buildDir');
    }

    _log('Step 1: Calculating MD5 hashes and renaming files...');
    await _calculateHashesAndRenameFiles();

    _log('\nStep 2: Updating asset references in HTML and JavaScript files...');
    await _updateAssetReferences();

    _log('\nStep 3: Generating version manifest...');
    await _generateManifest();

    _log('\nVersioning summary:');
    _log('- Total files versioned: ${_versionMap.length}');
    _log('- Manually versioned files (require manual updates):');
    for (final file in manuallyVersionedFiles) {
      _log('  * $file');
    }
  }

  Future<void> _calculateHashesAndRenameFiles() async {
    for (final filePath in autoVersionedFiles) {
      final file = File(path.join(buildDir, filePath));

      if (!file.existsSync()) {
        _log('Warning: File not found: $filePath');
        continue;
      }

      final bytes = await file.readAsBytes();
      final hash = md5.convert(bytes).toString();
      final shortHash = hash.substring(0, 8);

      // Generate versioned filename: filename.hash.ext
      final versionedFilename = _createVersionedFilename(filePath, shortHash);
      final versionedFile = File(path.join(buildDir, versionedFilename));

      await file.rename(versionedFile.path);

      // Store mapping: original -> versioned
      _versionMap[filePath] = versionedFilename;
      _hashMap[filePath] = shortHash;

      _log('✓ $filePath -> $versionedFilename');
    }
  }

  /// Creates a versioned filename by inserting the hash before the extension.
  /// Example: 'flutter_bootstrap.js' -> 'flutter_bootstrap.abc123.js'
  String _createVersionedFilename(String filename, String hash) {
    final parsedPath = path.split(filename);
    final basename = parsedPath.last;
    final dir = parsedPath.length > 1
        ? parsedPath.sublist(0, parsedPath.length - 1).join('/')
        : '';

    final lastDot = basename.lastIndexOf('.');
    if (lastDot == -1) {
      final versioned = '$basename.$hash';
      return dir.isEmpty ? versioned : '$dir/$versioned';
    }

    final name = basename.substring(0, lastDot);
    final ext = basename.substring(lastDot);
    final versioned = '$name.$hash$ext';
    return dir.isEmpty ? versioned : '$dir/$versioned';
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

    await manifestFile.writeAsString('$jsonString\n');
    _log('✓ Generated manifest: asset_versions.json');
  }

  void _log(String message) {
    if (verbose) {
      stdout.writeln(message);
    }
  }

  /// Updates all asset references in HTML and JavaScript files.
  /// Searches through all .html and .js files and replaces references
  /// to original filenames with their versioned equivalents.
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

        final escapedOriginal = RegExp.escape(originalPath);

        final patterns = [
          RegExp('"$escapedOriginal(?:\\?v=[^"]*)?"\s*'),
          RegExp("'$escapedOriginal(?:\\?v=[^']*)?'\s*"),
          RegExp(
            '"${RegExp.escape(originalPath.replaceAll(RegExp(r'\.[^.]+$'), ''))}\\.[a-f0-9]{8}${RegExp.escape(path.extension(originalPath))}"\s*',
          ),
        ];

        for (final pattern in patterns) {
          if (pattern.hasMatch(content)) {
            content = content.replaceAll(pattern, '"$versionedPath"');
            fileModified = true;
          }
        }
      }

      if (fileModified) {
        await file.writeAsString(content);
        _log('✓ Updated references in ${path.basename(file.path)}');
      }
    }
  }
}
