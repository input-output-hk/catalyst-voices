import 'dart:async';

import 'package:chopper/chopper.dart';

/// Workaround interceptor which only job is to get rid of unnecessary /api/ from request path
/// because base url already have it.
///
/// See https://github.com/input-output-hk/catalyst-internal-docs/issues/178
final class PathTrimInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) {
    final request = chain.request;
    final uri = request.uri;
    final pathSegments = List.of(uri.pathSegments);

    if (pathSegments.firstOrNull == 'api') {
      pathSegments.removeAt(0);
    }

    final updatedUri = uri.replace(pathSegments: pathSegments);
    final updatedRequest = request.copyWith(uri: updatedUri);

    return chain.proceed(updatedRequest);
  }
}
