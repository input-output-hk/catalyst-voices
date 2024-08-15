import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'file_picker_service.dart';
import 'secure_storage_service.dart';

class SecureCertificateRepository {
  static const String _certificateKeyPrefix = 'certificate_';
  static const String _certificateListKey = 'certificate_list';

  final SecureStorageService _storageService;
  final FilePickerService _filePickerService;

  SecureCertificateRepository({
    SecureStorageService? storageService,
    FilePickerService? filePickerService,
  })  : _storageService = storageService ?? SecureStorageService(),
        _filePickerService = filePickerService ?? FilePickerService();

  Future<bool> get hasPassword async => _storageService.hasPassword;

  bool get isAuthenticated => _storageService.isAuthenticated;

  Future<void> deleteAllCertificates() async {
    final certificateNames = await getStoredCertificateNames();
    for (final name in certificateNames) {
      await deleteCertificate(name);
    }
    await _storageService.delete(_certificateListKey);
  }

  Future<void> deleteCertificate(String certificateName) async {
    final certificateKey = _generateCertificateKey(certificateName);
    await _storageService.delete(certificateKey);
    final certificateList = await getStoredCertificateNames();
    certificateList.remove(certificateName);
    await _storeCertificateList(certificateList);
  }

  Future<void> deletePassword() async {
    _storageService.deletePassword();
  }

  Future<Uint8List?> getCertificate(String certificateName) async {
    final certificateKey = _generateCertificateKey(certificateName);
    return await _storageService.getBytes(certificateKey);
  }

  Future<List<String>> getStoredCertificateNames() async {
    final storedList = await _storageService.getString(_certificateListKey);
    if (storedList != null) {
      return storedList.split(',');
    }
    return [];
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
    await _addToCertificateList(storedCertificates);
    return storedCertificates;
  }

  Future<void> setPassword(String password) async {
    await _storageService.setPassword(password);
  }

  Future<void> _addToCertificateList(List<String> newCertificates) async {
    final existingList = await getStoredCertificateNames();
    existingList.addAll(newCertificates);
    await _storeCertificateList(existingList);
  }

  String _generateCertificateKey(String certificateName) {
    return '$_certificateKeyPrefix$certificateName';
  }

  bool _isCertificate(PlatformFile file) {
    return ['pem', 'crt', 'cer', 'der'].contains(file.extension?.toLowerCase());
  }

  Future<List<int>> _readFileAsBytes(PlatformFile file) async {
    if (file.bytes != null) {
      return file.bytes!;
    } else {
      throw Exception('No data available for file: ${file.name}');
    }
  }

  Future<void> _storeCertificateList(List<String> certificateList) async {
    await _storageService.saveString(
        _certificateListKey, certificateList.join(','));
  }
}
