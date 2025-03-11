import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';

/// An [Interceptor] which overrides the content-type header
/// for [supportedRequests].
///
/// The swagger_dart_code_generator package doesn't support
/// generating requests with application/cbor content-type,
/// instead it sends these requests as application/json.
final class CborContentTypeInterceptor implements Interceptor {
  static const headerKey = 'Content-Type';
  static const headerValue = 'application/cbor';
  static const supportedRequests = [
    (method: 'PUT', path: '/api/v1/document'),
  ];

  const CborContentTypeInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    var request = chain.request;

    for (final cborRequest in supportedRequests) {
      if (cborRequest.method.equalsIgnoreCase(request.method) &&
          cborRequest.path.equalsIgnoreCase(request.uri.path)) {
        request = applyHeader(request, headerKey, headerValue);
        break;
      }
    }

    return chain.proceed(request);
  }
}
