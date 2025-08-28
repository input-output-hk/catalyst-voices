/// This is copied from Cargokit (which is the official way to use it currently)
/// Details: https://fzyzcjy.github.io/flutter_rust_bridge/manual/integrate/builtin

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:toml/toml.dart';

class CrateInfo {
  final String packageName;

  CrateInfo({required this.packageName});

  static CrateInfo load(String manifestDir) {
    final manifestFile = File(path.join(manifestDir, 'Cargo.toml'));
    final manifest = manifestFile.readAsStringSync();
    return parseManifest(manifest, fileName: manifestFile.path);
  }

  static CrateInfo parseManifest(String manifest, {final String? fileName}) {
    final toml = TomlDocument.parse(manifest);
    final package = toml.toMap()['package'];
    if (package == null) {
      throw ManifestException('Missing package section', fileName: fileName);
    }
    final name = package['name'];
    if (name == null) {
      throw ManifestException('Missing package name', fileName: fileName);
    }
    return CrateInfo(packageName: name);
  }
}

class ManifestException {
  final String? fileName;

  final String message;
  ManifestException(this.message, {required this.fileName});

  @override
  String toString() {
    if (fileName != null) {
      return 'Failed to parse package manifest at $fileName: $message';
    } else {
      return 'Failed to parse package manifest: $message';
    }
  }
}
