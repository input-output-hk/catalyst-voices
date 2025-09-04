import 'dart:io';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

final _loggerDownloadsDirectory = Logger('DownloadsDirectorySaveStrategy');
final _loggerFilePicker = Logger('FilePickerSaveStrategy');

final class DownloadsDirectorySaveStrategy with FileNamingMixin implements FileSaveStrategy {
  const DownloadsDirectorySaveStrategy();

  @override
  bool get isSupported => !CatalystPlatform.isWeb;

  @override
  Future<String?> saveFile({
    required Uint8List data,
    required String filename,
    String? mimeType,
  }) async {
    try {
      final downloadDirectory = await getDownloadDirectory();

      final flavorName = isIOS ? '' : '_${envType.name}';
      var uniqueFilename = isIOS ? filename : flavorFileName(filename);
      var file = File('${downloadDirectory.path}/$uniqueFilename');

      // If file exists, add numbers like web browsers do
      var counter = 1;
      while (file.existsSync()) {
        uniqueFilename =
            '${parseFilenameWithoutExt(filename)}$flavorName($counter)${parseExtension(filename)}';
        file = File('${downloadDirectory.path}/$uniqueFilename');
        counter++;
      }

      await file.writeAsBytes(data);
      return file.path;
    } catch (e) {
      _loggerDownloadsDirectory.severe('Error saving file to downloads directory', e);
      rethrow;
    }
  }
}

mixin FileNamingMixin {
  AppEnvironmentType get envType => AppEnvironment.fromEnv().type;

  bool get isIOS => CatalystOperatingSystem.current.isIOS;

  String flavorFileName(String filename) {
    if (envType != AppEnvironmentType.prod) {
      return '${parseFilenameWithoutExt(filename)}_${envType.name}${parseExtension(filename)}';
    }
    return filename;
  }

  String parseExtension(String filename) => p.extension(filename);

  String parseFilenameWithoutExt(String filename) => p.basenameWithoutExtension(filename);
}

final class FilePickerSaveStrategy with FileNamingMixin implements FileSaveStrategy {
  const FilePickerSaveStrategy();

  @override
  bool get isSupported => true; // FilePicker should work on all platforms

  @override
  Future<String?> saveFile({
    required Uint8List data,
    required String filename,
    String? mimeType,
  }) async {
    try {
      await FilePicker.platform.saveFile(
        fileName: flavorFileName(filename),
        bytes: data,
      );
      return null;
    } catch (e) {
      _loggerFilePicker.severe('Error saving file with FilePicker', e);
      rethrow;
    }
  }
}

/// Abstract interface for file saving strategies
abstract interface class FileSaveStrategy {
  const FileSaveStrategy();

  /// Whether this strategy is supported on the current platform
  bool get isSupported;

  /// Saves the file represented by the [data] bytes with the given [filename].
  /// Returns the path where the file was saved.
  Future<String?> saveFile({
    required Uint8List data,
    required String filename,
    String? mimeType,
  });
}

/// Factory to get the appropriate file save strategy based on platform or preference
class FileSaveStrategyFactory {
  const FileSaveStrategyFactory();

  /// Returns the default strategy for the current platform
  static FileSaveStrategy getDefaultStrategy() {
    if (CatalystOperatingSystem.current.isIOS) {
      return getStrategy(type: FileSaveStrategyType.filePicker);
    } else {
      return getStrategy(type: FileSaveStrategyType.downloadsDirectory);
    }
  }

  static FileSaveStrategy getStrategy({required FileSaveStrategyType type}) {
    return switch (type) {
      FileSaveStrategyType.filePicker => const FilePickerSaveStrategy(),
      FileSaveStrategyType.downloadsDirectory => const DownloadsDirectorySaveStrategy(),
    };
  }
}

enum FileSaveStrategyType {
  filePicker,
  downloadsDirectory,
}
