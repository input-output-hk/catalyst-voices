import 'package:catalyst_voices_services/src/downloader/downloader.dart';
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
    Uri uri, {
    required Uri path,
  }) async {
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
