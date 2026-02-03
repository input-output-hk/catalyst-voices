import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';

/// Creates common [Dio] client [Interceptor]s.
class DioInterceptorFactory {
  Interceptor? authInterceptor(AuthTokenProvider? authTokenProvider) {
    return authTokenProvider != null ? RbacAuthInterceptor(authTokenProvider) : null;
  }

  Interceptor? logInterceptor([Logger? logger]) {
    logger ??= Logger('LogInterceptor');

    return kDebugMode
        ? LogInterceptor(logPrint: logger.fine, requestHeader: false, responseHeader: false)
        : null;
  }

  Interceptor retryInterceptor([Interceptor? authInterceptor]) {
    final retryDio = Dio();

    final retryInterceptor = RetryInterceptor(
      // RetryInterceptor suggests to use the original dio however this creates a problem
      // of a chicken and egg but also causes all interceptors to trigger their logic
      // on the retry. As we only want some of them on the retry request (auth but not logger) we
      // are recreating a dio here with a custom list of interceptors that are reused on the retry.
      dio: retryDio,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 4),
      ],
    );

    retryDio.interceptors.addAll([
      ?authInterceptor,
      retryInterceptor,
    ]);

    return retryInterceptor;
  }
}
