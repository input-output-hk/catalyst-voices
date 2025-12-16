import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';

/// Creates common [Dio] client [Interceptor]s.
class DioInterceptorFactory {
  LogInterceptor? logInterceptor() {
    final catApiServiceLogger = Logger('CatApiServices');

    return kDebugMode ? LogInterceptor(logPrint: catApiServiceLogger.fine) : null;
  }

  RbacAuthInterceptor? rbacAuthInterceptor(AuthTokenProvider? authTokenProvider) {
    return authTokenProvider != null ? RbacAuthInterceptor(authTokenProvider) : null;
  }

  RetryInterceptor retryInterceptor([RbacAuthInterceptor? rbacInterceptor]) {
    final retryDio = Dio();
    if (rbacInterceptor != null) {
      retryDio.interceptors.add(rbacInterceptor);
    }

    return RetryInterceptor(
      dio: retryDio,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 4),
      ],
    );
  }
}
