import 'dart:typed_data';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/downloader/utils/downloader.dart';
import 'package:path/path.dart' as p;
import 'package:web/web.dart' as web;

Downloader getDownloader() => const WebDownloader();

/// Web only implementation of [Downloader].
final class WebDownloader implements Downloader {
  const WebDownloader();

  /// [download] method only takes filename from [path] and ignores other
  /// data.
  @override
  Future<void> download(
    Uint8List data, {
    required Uri path,
    String mimeType = DownloaderService.bytesMimeType,
  }) async {
    final uri = Uri.dataFromBytes(
      data,
      mimeType: mimeType,
    );

    final filename = p.basename(path.path);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = uri.toString()
      ..style.display = 'none'
      ..download = filename;

    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
  }
}
