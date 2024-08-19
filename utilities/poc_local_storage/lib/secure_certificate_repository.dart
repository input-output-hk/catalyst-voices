import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'crypto_service.dart';
import 'file_picker_service.dart';
import 'secure_storage_service.dart';

class SecureCertificateRepository {
  static const String _certificateKeyPrefix = 'certificate_';
  static const String _certificateListKey = 'certificate_list';

  final SecureStorageService _storageService;
  final FilePickerService _filePickerService;
  final CryptoService _cryptoService;

  SecureCertificateRepository({
    SecureStorageService? storageService,
    FilePickerService? filePickerService,
    CryptoService? cryptoService,
  })  : _storageService = storageService ?? SecureStorageService(),
        _filePickerService = filePickerService ?? FilePickerService(),
        _cryptoService = cryptoService ?? CryptoService();

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
    await _storageService.deletePassword();
  }

  Future<String?> getCertificate(
      String certificateName, String password) async {
    if (!_storageService.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    final certificateKey = _generateCertificateKey(certificateName);
    final encryptedCertificate = await _storageService.getBytes(certificateKey);
    if (encryptedCertificate != null) {
      try {
        final decryptedBytes =
            _cryptoService.decrypt(encryptedCertificate, password);
        final decodedCertificate = utf8.decode(decryptedBytes);
        print('Decrypted certificate: $decodedCertificate'); // Debug print
        return decodedCertificate;
      } catch (e) {
        print('Error decrypting certificate: $e');
        rethrow;
      }
    } else {
      print('No encrypted certificate found for key: $certificateKey');
      return null;
    }
  }

  Future<List<String>> getStoredCertificateNames() async {
    final storedList = await _storageService.getString(_certificateListKey);
    if (storedList != null && storedList.isNotEmpty) {
      return storedList.split(',');
    }
    return [];
  }

  Future<List<String>> pickAndStoreCertificates(String password) async {
    if (!_storageService.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    final files = await _filePickerService.pickMultipleFiles();
    print('Picked files: ${files.map((file) => file.name).toList()}');
    final storedCertificates = <String>[];

    for (final file in files) {
      if (_isCertificate(file)) {
        final certificateBytes = await _readFileAsBytes(file);
        print(
            'Original certificate content: ${utf8.decode(certificateBytes)}'); // Debug print
        final encryptedBytes =
            _cryptoService.encrypt(certificateBytes, password);
        final certificateKey = _generateCertificateKey(file.name);

        await _storageService.saveBytes(certificateKey, encryptedBytes);
        storedCertificates.add(file.name);

        // Verify storage
        final storedEncryptedBytes =
            await _storageService.getBytes(certificateKey);
        print(
            'Stored encrypted bytes length: ${storedEncryptedBytes?.length}'); // Debug print
      }
    }

    print('Stored certificates: $storedCertificates');
    await _addToCertificateList(storedCertificates);
    return storedCertificates;
  }

  Future<void> setPassword(String password) async {
    await _storageService.setPassword(password);
  }

  Future<bool> verifyPassword(String password) async {
    return await _storageService.login(password);
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

  Future<Uint8List> _readFileAsBytes(PlatformFile file) async {
    if (file.bytes != null) {
      return file.bytes!;
    } else {
      throw Exception('No data available for file: ${file.name}');
    }
  }

  Future<void> _storeCertificateList(List<String> certificateList) async {
    await _storageService.saveString(
      _certificateListKey,
      certificateList.join(','),
    );
  }
}
