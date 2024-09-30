//ignore_for_file: one_member_abstracts

import 'package:catalyst_voices_services/src/downloader/io_downloader.dart';
import 'package:catalyst_voices_services/src/downloader/web_downloader.dart';
import 'package:flutter/foundation.dart';

/// Abstract interface class for downloading data.
///
/// This class provides a factory method to create the appropriate downloader
/// based on the current platform. On web platforms, it creates a
/// [WebDownloader], while on other platforms, it creates an [IODownloader].
abstract interface class Downloader {
  factory Downloader() {
    if (kIsWeb) {
      return const WebDownloader();
    } else {
      return const IODownloader();
    }
  }

  /// Downloads data from the specified [uri] and saves it to the specified
  /// [path].
  Future<void> download(
    Uri uri, {
    required Uri path,
  });
}
