//ignore_for_file: one_member_abstracts

import 'package:catalyst_voices_services/src/downloader/downloader_stub.dart'
    if (dart.library.io) 'io_downloader.dart'
    if (dart.library.html) 'web_downloader.dart';

/// Abstract interface class for downloading data.
abstract interface class Downloader {
  factory Downloader() => getDownloader();

  /// Downloads data from the specified [uri] and saves it to the specified
  /// [path].
  Future<void> download(
    Uri uri, {
    required Uri path,
  });
}
