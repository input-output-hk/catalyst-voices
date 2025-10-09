import 'package:catalyst_voices_services/src/downloader/utils/file_save_strategy.dart';
import 'package:downloadsfolder/downloadsfolder.dart';

/// Mixin that provides common file path helper methods for services
/// that need to work with download directories and file paths.
mixin FilePathHelperMixin {
  /// Gets the download directory path if the strategy requires it.
  /// Returns null for strategies that don't need a specific directory.
  Future<String?> getDownloadPathIfNeeded(FileSaveStrategyType strategyType) async {
    if (strategyType == FileSaveStrategyType.downloadsDirectory) {
      final downloadDir = await getDownloadDirectory();
      return downloadDir.path;
    }
    return null;
  }
}
