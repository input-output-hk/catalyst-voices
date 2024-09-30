import 'package:catalyst_voices_services/src/downloader/downloader.dart';

Downloader getDownloader() => const IODownloader();

final class IODownloader implements Downloader {
  const IODownloader();

  @override
  Future<void> download(
    Uri uri, {
    required Uri path,
  }) {
    throw UnimplementedError('IO Downloader not implemented');
  }
}
