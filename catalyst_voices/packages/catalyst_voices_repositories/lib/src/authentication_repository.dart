import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

final class AuthenticationRepository {
  final CredentialsStorageRepository credentialsStorageRepository;
  final _controller = StreamController<AuthenticationStatus>();

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

    yield* _controller.stream;
  }

  Future<void> dispose() async => _controller.close();

  Future<SessionData?> getSessionData() async {
    try {
      final sessionData = await credentialsStorageRepository.getSessionData();

      print('getSessionData: $sessionData');

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
    _controller.add(AuthenticationStatus.unauthenticated);
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
      () => _controller.add(AuthenticationStatus.authenticated),
    );
  }
}
