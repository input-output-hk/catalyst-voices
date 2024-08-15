import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'file_picker_service.dart';
import 'secure_storage_service.dart';

class SecureCertificateRepository {
  static const String _certificateKeyPrefix = 'certificate_';

  final SecureStorageService _storageService;
  final FilePickerService _filePickerService;

  SecureCertificateRepository({
    SecureStorageService? storageService,
    FilePickerService? filePickerService,
  })  : _storageService = storageService ?? SecureStorageService(),
        _filePickerService = filePickerService ?? FilePickerService();

  Future<void> deleteAllCertificates() async {
    final allKeys = await _getAllKeys();
    for (final key in allKeys) {
      if (key.startsWith(_certificateKeyPrefix)) {
        await _storageService.delete(key);
      }
    }
  }

  Future<void> deleteCertificate(String certificateName) async {
    final certificateKey = _generateCertificateKey(certificateName);
    await _storageService.delete(certificateKey);
  }

  Future<void> deletePassword() async {
    _storageService.deletePassword();
  }

  Future<Uint8List?> getCertificate(String certificateName) async {
    final certificateKey = _generateCertificateKey(certificateName);
    return await _storageService.getBytes(certificateKey);
  }

  Future<List<String>> getStoredCertificateNames() async {
    final allKeys = await _getAllKeys();
    print('All keys: $allKeys');
    return allKeys
        .where((key) => key.startsWith(_certificateKeyPrefix))
        .map((key) => key.substring(_certificateKeyPrefix.length))
        .toList();
  }

  Future<List<String>> pickAndStoreCertificates() async {
    final files = await _filePickerService.pickMultipleFiles();
    print('Picked files: ${files.map((file) => file.name).toList()}');
    final storedCertificates = <String>[];

    for (final file in files) {
      if (_isCertificate(file)) {
        final certificateBytes = await _readFileAsBytes(file);
        final certificateKey = _generateCertificateKey(file.name);

        await _storageService.saveBytes(
          certificateKey,
          Uint8List.fromList(certificateBytes),
        );
        storedCertificates.add(file.name);
      }
    }

    print('Stored certificates: $storedCertificates');
    return storedCertificates;
  }

  String _generateCertificateKey(String certificateName) {
    return '$_certificateKeyPrefix$certificateName';
  }

  Future<List<String>> _getAllKeys() async {
    // This is a workaround since we can't directly access all keys
    // We'll try to read a non-existent key to get all keys
    final dummyKey = 'dummy_key_${DateTime.now().millisecondsSinceEpoch}';
    await _storageService.getString(dummyKey);

    print('Dummy key: $dummyKey');
    // Now, we'll read all certificate keys by checking for their prefix
    final allKeys = <String>[];
    var i = 0;
    while (true) {
      final key = '${_certificateKeyPrefix}$i';
      final value = await _storageService.getString(key);
      if (value == null) break;
      allKeys.add(key);
      i++;
    }
    return allKeys;
  }

  bool _isCertificate(PlatformFile file) {
    return ['pem'].contains(file.extension?.toLowerCase());
  }

  Future<List<int>> _readFileAsBytes(PlatformFile file) async {
    if (file.bytes != null) {
      return file.bytes!;
    } else {
      throw Exception('No data available for file: ${file.name}');
    }
  }
}
