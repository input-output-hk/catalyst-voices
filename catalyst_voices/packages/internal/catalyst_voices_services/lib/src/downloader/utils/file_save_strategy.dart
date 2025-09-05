import 'dart:io';
import 'dart:typed_data';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

final _loggerDownloadsDirectory = Logger('DownloadsDirectorySaveStrategy');
final _loggerFilePicker = Logger('FilePickerSaveStrategy');

final class DownloadsDirectorySaveStrategy implements FileSaveStrategy {
  const DownloadsDirectorySaveStrategy();

  @override
  Future<String?> saveFile({
    required Uint8List data,
    required Uri fileUri,
  }) async {
    try {
      var file = File.fromUri(fileUri);

      // If file exists, add numbers like web browsers do
      var counter = 1;
      while (file.existsSync()) {
        final pathWithoutExt = p.withoutExtension(fileUri.path);
        final extension = p.extension(fileUri.path);
        final newPath = '$pathWithoutExt ($counter)$extension';
        final newUri = Uri.file(newPath, windows: false);
        file = File.fromUri(newUri);
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

final class FilePickerSaveStrategy implements FileSaveStrategy {
  const FilePickerSaveStrategy();

  @override
  Future<String?> saveFile({
    required Uint8List data,
    required Uri fileUri,
  }) async {
    try {
      final fileName = fileUri.path;

      await FilePicker.platform.saveFile(
        fileName: fileName,
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
// ignore: one_member_abstracts
abstract interface class FileSaveStrategy {
  const FileSaveStrategy();

  /// Saves the file represented by the [data] bytes with the given [fileUri].
  /// Returns the path where the file was saved.
  Future<String?> saveFile({
    required Uint8List data,
    required Uri fileUri,
  });
}

/// Factory to get the appropriate file save strategy based on platform or preference
class FileSaveStrategyFactory {
  const FileSaveStrategyFactory();

  /// Returns the default strategy for the current platform
  static FileSaveStrategyType getDefaultStrategyType() {
    return switch (CatalystOperatingSystem.current) {
      _ when CatalystPlatform.isWeb || CatalystOperatingSystem.current.isIOS =>
        FileSaveStrategyType.filePicker,
      _ => FileSaveStrategyType.downloadsDirectory,
    };
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
