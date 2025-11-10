import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('WASM build type', () {
    const String mainPath = "scripts/version_web_assets/test";
    final src = Directory('$mainPath/helper/build_wasm');
    final dst = Directory('$mainPath/helper/tmp');

    setUpAll(() async {
      if (dst.existsSync()) {
        await dst.delete(recursive: true);
      }
      dst.createSync(recursive: true);

      await for (var entity in src.list(recursive: false)) {
        final name = path.basename(entity.path);
        if (entity is File) {
          await entity.copy('${dst.path}/$name');
        } else if (entity is Directory) {
          await _copyDir(entity, Directory('${dst.path}/$name'));
        }
      }

      await Process.run('dart', [
        'run',
        'scripts/version_web_assets/version_web_assets.dart',
        '--wasm=true',
        '--build-dir=${dst.path}',
      ]);
    });

    tearDown(() async {
      if (await dst.exists()) {
        await dst.delete(recursive: true);
      }
    });

    test("WebAssetVersioner find manually version files", () async {
      final file = File('${dst.path}/asset_version.json');
      final fileData = file.readAsStringSync();
      final json = jsonDecode(fileData) as Map<String, dynamic>;
      print(json);

      expect(file.existsSync(), isTrue);
      expect(json['asset_hashes']['sqlite3.wasm'], '1');
      expect(json['asset_hashes']['drift_worker.js'], '');
    });

    test(
      "WebAssetVersioner add same hash for symbols file as parent has",
      () async {
        final file = File('${dst.path}/asset_version.json');
        final fileData = file.readAsStringSync();
        final json = jsonDecode(fileData) as Map<String, dynamic>;

        final parentHash =
            json['asset_hashes']['canvaskit/skwasm_heavy.js'] as String;
        final symbolHash =
            json['asset_hashes']['canvaskit/skwasm_heavy.js.symbols'] as String;

        expect(file.existsSync(), isTrue);
        expect(parentHash, symbolHash);
      },
    );
  });
}

Future<void> _copyDir(Directory source, Directory destination) async {
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }

  await for (var entity in source.list(recursive: false)) {
    final name = path.basename(entity.path);

    if (entity is File) {
      await entity.copy('${destination.path}/$name');
    } else if (entity is Directory) {
      await _copyDir(entity, Directory('${destination.path}/$name'));
    }
  }
}
