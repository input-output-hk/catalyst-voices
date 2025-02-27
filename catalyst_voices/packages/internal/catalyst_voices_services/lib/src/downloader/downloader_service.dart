import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices_services/src/downloader/utils/downloader.dart';

// ignore: one_member_abstracts
abstract interface class DownloaderService {
  static const bytesMimeType = 'application/octet-stream';

  const factory DownloaderService() = DownloaderServiceImpl;

  Future<void> download({
    required Uint8List data,
    required String filename,
    String mimeType = DownloaderService.bytesMimeType,
  });
}

final class DownloaderServiceImpl implements DownloaderService {
  const DownloaderServiceImpl();

  Downloader get _downloader => Downloader();

  @override
  Future<void> download({
    required Uint8List data,
    required String filename,
    String mimeType = DownloaderService.bytesMimeType,
  }) async {
    await _downloader.download(
      data,
      path: Uri(path: filename),
      mimeType: mimeType,
    );
  }
}
