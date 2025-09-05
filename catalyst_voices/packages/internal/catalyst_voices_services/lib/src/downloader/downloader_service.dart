import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/common/file_path_helper_mixin.dart';
import 'package:catalyst_voices_services/src/downloader/utils/file_save_strategy.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:path/path.dart' as p;

// ignore: one_member_abstracts
abstract interface class DownloaderService {
  const factory DownloaderService() = DownloaderServiceImpl;

  Future<String?> download({
    required Uint8List data,
    required String filename,
  });
}

final class DownloaderServiceImpl with FilePathHelperMixin implements DownloaderService {
  const DownloaderServiceImpl();

  @override
  Future<String?> download({
    required Uint8List data,
    required String filename,
  }) async {
    final envType = AppEnvironment.fromEnv().type;
    final strategyType = FileSaveStrategyFactory.getDefaultStrategyType();
    final strategy = FileSaveStrategyFactory.getStrategy(type: strategyType);

    final fileUri = await _buildSaveUri(filename, strategyType, envType);

    return strategy.saveFile(
      data: data,
      fileUri: fileUri,
    );
  }

  Future<Uri> _buildSaveUri(
    String filename,
    FileSaveStrategyType strategyType,
    AppEnvironmentType envType,
  ) async {
    final flavorName = _getFlavorName(strategyType, envType);
    final fileWithoutExtension = p.withoutExtension(filename);
    final extensionName = p.extension(filename);

    final downloadPath = await getDownloadPathIfNeeded(strategyType);
    final uniqueFilename = '$fileWithoutExtension$flavorName$extensionName';

    return Uri.file(
      downloadPath != null ? '$downloadPath/$uniqueFilename' : uniqueFilename,
      windows: false,
    );
  }

  String _getFlavorName(FileSaveStrategyType strategyType, AppEnvironmentType envType) {
    if (strategyType == FileSaveStrategyType.filePicker) {
      return envType.fileFlavorName;
    } else {
      // For downloads directory, skip flavor on iOS
      return CatalystOperatingSystem.current.isIOS ? '' : envType.fileFlavorName;
    }
  }
}

extension on AppEnvironmentType {
  String get fileFlavorName => switch (this) {
    AppEnvironmentType.dev => '_dev',
    AppEnvironmentType.preprod => '_preprod',
    _ => '',
  };
}
