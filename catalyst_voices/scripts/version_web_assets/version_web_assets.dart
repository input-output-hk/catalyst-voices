import 'dart:io';

import 'package:args/args.dart';

import 'web_asset_versioner.dart';

/// Versions Flutter web assets by renaming files with content-based MD5 hashes
/// to prevent browser caching issues.
///
/// Usage: dart run version_web_assets.dart [build-dir]
/// - build-dir: Path to the build/web directory (default: apps/voices/build/web)
///
/// This script:
/// 1. Calculates MD5 hash for each auto-versioned file and renames them
/// 2. Updates all asset references in HTML and JavaScript files
/// 3. Generates a manifest file with all versioned assets
Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'build-dir',
      abbr: 'b',
      defaultsTo: 'apps/voices/build/web',
      help: 'Path to the build/web directory',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      defaultsTo: true,
      help: 'Enable verbose logging',
    )
    ..addOption(
      'wasm',
      abbr: 'w',
      defaultsTo: 'true',
      allowed: ['true', 'false'],
      help: 'Include main.dart.wasm in versioning (true/false)',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show usage information',
    );

  ArgResults argResults;
  try {
    argResults = parser.parse(args);
  } catch (e) {
    stderr.writeln('Error parsing arguments: $e');
    _printUsage(parser);
    exitCode = 1;
    return;
  }

  if (argResults['help'] as bool) {
    _printUsage(parser);
    return;
  }

  final buildDir = argResults['build-dir'] as String;
  final verbose = argResults['verbose'] as bool;
  final wasm = (argResults['wasm'] as String) == 'true';

  final versioner = WebAssetVersioner(
    buildDir: buildDir,
    verbose: verbose,
    wasm: wasm,
  );

  try {
    await versioner.versionAssets();
    stdout.writeln('\n✓ Web asset versioning completed successfully!');
  } catch (e, stackTrace) {
    stderr.writeln('\n✗ Error versioning web assets: $e');
    if (verbose) {
      stderr.writeln(stackTrace);
    }
    exitCode = 1;
  }
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Usage: dart run version_web_assets.dart [options]');
  stdout.writeln('\nVersions Flutter web assets with content-based MD5 hashes');
  stdout.writeln('\nOptions:');
  stdout.writeln(parser.usage);
}
