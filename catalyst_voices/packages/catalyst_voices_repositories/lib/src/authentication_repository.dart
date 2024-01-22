import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

final class AuthenticationRepository {
  final CredentialsStorageRepository credentialsStorageRepository;
  final _streamController = StreamController<AuthenticationStatus>();

  AuthenticationRepository({required this.credentialsStorageRepository});

  Stream<AuthenticationStatus> get status async* {
    try {
      final sessionData = await credentialsStorageRepository.getSessionData();

      if (sessionData.isSuccess) {
        yield AuthenticationStatus.authenticated;
      } else {
        yield AuthenticationStatus.unauthenticated;
      }
    } catch (error) {
      yield AuthenticationStatus.unknown;
    }

    yield* _streamController.stream;
  }

  Future<void> dispose() async => _streamController.close();

  Future<SessionData?> getSessionData() async {
    try {
      final sessionData = await credentialsStorageRepository.getSessionData();

      if (sessionData.isSuccess) {
        return sessionData.success;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  void logOut() {
    credentialsStorageRepository.clearSessionData;
    _streamController.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await credentialsStorageRepository.storeSessionData(
      SessionData(
        email: email,
        password: password,
      ),
    );

    // TODO(minikin): remove this delay after implementing real auth flow.
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _streamController.add(AuthenticationStatus.authenticated),
    );
  }
}
