import 'dart:typed_data';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/downloader/utils/downloader.dart';
import 'package:catalyst_voices_services/src/downloader/utils/file_save_strategy.dart';
import 'package:path/path.dart' as p;

Downloader getDownloader() => const IODownloader();

final class IODownloader implements Downloader {
  final FileSaveStrategy? _strategy;

  const IODownloader([this._strategy]);

  @override
  Future<String?> download(
    Uint8List data, {
    required Uri path,
    String mimeType = DownloaderService.bytesMimeType,
  }) async {
    final strategy = _strategy ?? FileSaveStrategyFactory.getDefaultStrategy();

    // Extract the filename from the path
    final filename = p.basename(path.path);

    // Save the file using the strategy
    final savedFile = await strategy.saveFile(
      data: data,
      filename: filename,
      mimeType: mimeType,
    );

    return savedFile;
  }
}
