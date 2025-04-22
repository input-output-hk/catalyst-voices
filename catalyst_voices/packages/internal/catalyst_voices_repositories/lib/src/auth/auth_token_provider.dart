import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';

/// Generates auth tokens for [RbacAuthInterceptor].
// ignore: one_member_abstracts
abstract interface class AuthTokenProvider {
  /// Creates a new authentication token.
  ///
  /// The returned token might be cached if it is still valid.
  ///
  /// Returns null if creating a token is not possible,
  /// i.e. due to account being locked or not existing.
  ///
  /// Use [forceRefresh] if you want newly created token.
  Future<RbacToken?> createRbacToken({bool forceRefresh});
}
