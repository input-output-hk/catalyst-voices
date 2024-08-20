// ignore_for_file: inference_failure_on_untyped_parameter

import 'dart:async';

import 'package:file_picker/file_picker.dart';

/// A service for picking files from the device.
final class FilePickerService {
  static final FilePickerService _instance = FilePickerService._();

  factory FilePickerService() => _instance;

  FilePickerService._();

  Future<List<PlatformFile>> pickMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    return result?.files ?? [];
  }

  Future<List<List<int>>> pickMultipleFilesAsBytes() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      return result.files
          .map((file) => file.bytes ?? List<int>.empty())
          .toList();
    }
    return [];
  }

  Future<List<int>?> pickSingleFileAsBytes() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first.bytes;
    }
    return null;
  }
}

extension PlatformFileExtension on PlatformFile {
  bool get isCertificate => ['pem'].contains(extension?.toLowerCase());

  Future<List<int>> readAsBytes() async {
    if (bytes != null) {
      return bytes!;
    } else if (readStream != null) {
      final completer = Completer<List<int>>();
      final chunks = <int>[];

      readStream!.listen(
        chunks.addAll,
        onError: (error) {
          completer.completeError(error as Object);
        },
        onDone: () {
          completer.complete(chunks);
        },
        cancelOnError: true,
      );

      return completer.future;
    } else {
      throw Exception('No data available for file: $name');
    }
  }

  Future<String> readAsString() async {
    final fileBytes = await readAsBytes();
    return String.fromCharCodes(fileBytes);
  }
}
