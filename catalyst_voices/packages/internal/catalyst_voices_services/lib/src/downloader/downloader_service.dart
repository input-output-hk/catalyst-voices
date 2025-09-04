import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/downloader/utils/file_save_strategy.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:path/path.dart' as p;

// ignore: one_member_abstracts
abstract interface class DownloaderService {
  const factory DownloaderService() = DownloaderServiceImpl;

  Future<String?> download({
    required Uint8List data,
    required String filename,
  });
}

final class DownloaderServiceImpl implements DownloaderService {
  const DownloaderServiceImpl();

  @override
  Future<String?> download({
    required Uint8List data,
    required String filename,
  }) async {
    final envType = AppEnvironment.fromEnv().type;
    final strategy = FileSaveStrategyFactory.getDefaultStrategy();

    final fileUri = await _buildSaveUri(filename, strategy, envType);

    return strategy.saveFile(
      data: data,
      fileUri: fileUri,
    );
  }

  Future<Uri> _buildSaveUri(
    String filename,
    FileSaveStrategy strategy,
    AppEnvironmentType envType,
  ) async {
    final flavorName = _getFlavorName(strategy, envType);
    final fileWithoutExtension = p.withoutExtension(filename);
    final extensionName = p.extension(filename);

    final downloadPath = await _getDownloadPathIfNeeded(strategy);
    final uniqueFilename = '$fileWithoutExtension$flavorName$extensionName';

    return Uri.file(
      downloadPath != null ? '$downloadPath/$uniqueFilename' : uniqueFilename,
      windows: false,
    );
  }

  Future<String?> _getDownloadPathIfNeeded(FileSaveStrategy strategy) async {
    if (strategy.type == FileSaveStrategyType.downloadsDirectory) {
      final downloadDir = await getDownloadDirectory();
      return downloadDir.path;
    }
    return null;
  }

  String _getFlavorName(FileSaveStrategy strategy, AppEnvironmentType envType) {
    if (strategy.type == FileSaveStrategyType.filePicker) {
      return envType.fileFlavorName;
    } else {
      // For downloads directory, skip flavor on iOS
      return CatalystOperatingSystem.current.isIOS ? '' : envType.fileFlavorName;
    }
  }
}

extension AppEnvironmentTypeName on AppEnvironmentType {
  String get fileFlavorName => switch (this) {
    AppEnvironmentType.dev => '_dev',
    AppEnvironmentType.preprod => '_preprod',
    _ => '',
  };
}
