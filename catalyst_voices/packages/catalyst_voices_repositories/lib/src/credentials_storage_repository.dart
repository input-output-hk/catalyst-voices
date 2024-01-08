import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:result_type/result_type.dart';

/// This is a temporary implementation of CredentialsStorageRepository
/// It's only used to set-up state management for now.
/// It will be replaced by a proper implementation as soon as authentication
/// flow will be defined.
final class CredentialsStorageRepository {
  final SecureStorageService secureStorageService;

  const CredentialsStorageRepository({required this.secureStorageService});

  void get clearSessionData => secureStorageService.deleteAll;

  Future<Result<SessionData?, SecureStorageError>> getSessionData() async {
    try {
      final email = await secureStorageService.get(
        SecureStorageKeysConst.dummyEmail,
      );

      final password = await secureStorageService.get(
        SecureStorageKeysConst.dummyPassword,
      );

      if (email == null || password == null) {
        return Success(null);
      }

      return Success(
        SessionData(
          email: email,
          password: password,
        ),
      );
    } on SecureStorageError catch (_) {
      return Failure(SecureStorageError.canNotReadData);
    }
  }

  Future<Result<void, SecureStorageError>> storeSessionData(
    SessionData sessionData,
  ) async {
    try {
      await secureStorageService.set(
        SecureStorageKeysConst.dummyEmail,
        sessionData.email,
      );

      await secureStorageService.set(
        SecureStorageKeysConst.dummyPassword,
        sessionData.password,
      );
      return Success(null);
    } on SecureStorageError catch (_) {
      return Failure(SecureStorageError.canNotSaveData);
    }
  }
}
