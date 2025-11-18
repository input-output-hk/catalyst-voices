import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('WASM build type', () {
    const String mainPath = "scripts/version_web_assets/test";
    final src = Directory('$mainPath/helper/build_wasm');
    final dst = Directory('$mainPath/helper/tmp');
    late final Map<String, dynamic> assetVersionData;

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

      final file = File('${dst.path}/asset_version.json');
      final fileData = file.readAsStringSync();
      assetVersionData = jsonDecode(fileData) as Map<String, dynamic>;
    });

    tearDownAll(() async {
      if (await dst.exists()) {
        await dst.delete(recursive: true);
      }
    });

    test("WebAssetVersioner find manually version files", () async {
      expect(assetVersionData['asset_hashes']['sqlite3.wasm'], '1');
      expect(assetVersionData['asset_hashes']['drift_worker.js'], '1');
    });

    test(
      "WebAssetVersioner add same hash for symbols file as parent has",
      () async {
        final parentHash =
            assetVersionData['asset_hashes']['canvaskit/skwasm_heavy.js'] // cspell:disable-line
                as String;
        final symbolHash =
            assetVersionData['asset_hashes']['canvaskit/skwasm_heavy.js.symbols'] // cspell:disable-line
                as String;

        expect(parentHash, symbolHash);
      },
    );

    test('DirectRefUpdater updates correctly refs', () {
      final versionedCanvaskit =
          assetVersionData['versioned_assets']['canvaskit/canvaskit.js']
              as String;
      final file = File('${dst.path}/$versionedCanvaskit');
      final content = file.readAsStringSync();

      final versionedCanvaskitWasm =
          assetVersionData['asset_hashes']['canvaskit/canvaskit.wasm']
              as String;

      final wasmRef = content.contains(versionedCanvaskitWasm);
      final notContainsNoVersionWasm = !content.contains(
        'canvaskit/canvaskit.wasm',
      );

      expect(wasmRef, isTrue);
      expect(notContainsNoVersionWasm, isTrue);
    });
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
