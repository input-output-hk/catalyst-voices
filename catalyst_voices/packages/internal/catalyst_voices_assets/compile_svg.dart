// ignore_for_file: avoid_print
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';

Future<void> main() async {
  initializePathOpsFromFlutterCache();

  final inputDir = Directory('assets_svg_source');

  final svgFiles = await inputDir
      .list(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.svg'))
      .cast<File>()
      .toList();

  print('Found ${svgFiles.length} SVG files');

  for (final svgFile in svgFiles) {
    final relativePath = path.relative(svgFile.path, from: 'assets_svg_source');
    final outputPath = path.join('assets', relativePath);
    final outputFile = File(outputPath);

    await outputFile.parent.create(recursive: true);

    print('Compiling: ${svgFile.path}');

    final svgString = await svgFile.readAsString();
    // --no-optimize-overdraw - https://github.com/flutter/flutter/issues/174619
    final result = encodeSvg(
      xml: svgString,
      debugName: outputPath,
      enableOverdrawOptimizer: false,
    );

    await outputFile.writeAsBytes(result);
  }
}
