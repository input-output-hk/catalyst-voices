import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';

/// Generates auth tokens for [RbacAuthInterceptor].
// ignore: one_member_abstracts
abstract interface class AuthTokenProvider {
  /// Creates a new authentication token.
  ///
  /// The returned token might be cached if it is still valid.
  Future<String> createRbacToken();
}
