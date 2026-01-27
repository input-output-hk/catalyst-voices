import 'package:catalyst_voices_services/src/common/file_path_helper_mixin.dart';
import 'package:catalyst_voices_services/src/downloader/utils/file_save_strategy.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

// ignore: one_member_abstracts
abstract interface class UploaderService {
  const factory UploaderService() = UploaderServiceImpl;

  Future<XFile?> uploadFile({
    List<String>? allowedExtensions,
  });
}

final class UploaderServiceImpl with FilePathHelperMixin implements UploaderService {
  const UploaderServiceImpl();

  @override
  Future<XFile?> uploadFile({List<String>? allowedExtensions}) async {
    final pickStrategy = FileSaveStrategyFactory.getDefaultStrategyType();
    final initialDirectory = await getDownloadPathIfNeeded(pickStrategy);

    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
      initialDirectory: initialDirectory,
    );
    final file = result?.files.single;
    final name = file?.name;
    final bytes = file?.bytes;

    if (name != null && bytes != null) {
      return file?.xFile;
    }

    return null;
  }
}
