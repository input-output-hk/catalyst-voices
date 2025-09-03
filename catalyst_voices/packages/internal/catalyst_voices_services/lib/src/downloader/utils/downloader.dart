//ignore_for_file: one_member_abstracts

import 'dart:typed_data';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/downloader/utils/downloader_stub.dart'
    if (dart.library.io) 'io_downloader.dart'
    if (dart.library.html) 'web_downloader.dart';

/// Abstract interface class for downloading data.
abstract interface class Downloader {
  factory Downloader() => getDownloader();

  /// Saves the file represented by the [data] bytes under specified [path].
  /// It might returns String with path where file was saved.
  Future<String?> download(
    Uint8List data, {
    required Uri path,
    String mimeType = DownloaderService.bytesMimeType,
  });
}
