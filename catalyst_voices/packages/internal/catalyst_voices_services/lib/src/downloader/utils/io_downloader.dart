import 'dart:typed_data';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/downloader/utils/downloader.dart';

Downloader getDownloader() => const IODownloader();

final class IODownloader implements Downloader {
  const IODownloader();

  @override
  Future<void> download(
    Uint8List data, {
    required Uri path,
    String mimeType = DownloaderService.bytesMimeType,
  }) {
    throw UnimplementedError('IO Downloader not implemented');
  }
}
