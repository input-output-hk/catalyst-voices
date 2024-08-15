import 'dart:async';

import 'package:file_picker/file_picker.dart';

final class FilePickerService {
  static final FilePickerService _instance = FilePickerService._();

  factory FilePickerService() => _instance;

  FilePickerService._();

  Future<List<PlatformFile>> pickMultipleFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      withData: true,
    );

    return result?.files ?? [];
  }

  Future<List<List<int>>> pickMultipleFilesAsBytes() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
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
        (List<int> chunk) {
          chunks.addAll(chunk);
        },
        onError: (error) {
          completer.completeError(error);
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
