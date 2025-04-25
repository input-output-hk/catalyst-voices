import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';

extension RbacTokenExt on RbacToken {
  /// The auth token header to be used with [RbacAuthInterceptor].
  String authHeader() => 'Bearer $value';
}
