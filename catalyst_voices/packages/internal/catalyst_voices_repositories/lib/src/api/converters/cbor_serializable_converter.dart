import 'dart:async';

import 'package:chopper/chopper.dart';

/// A [Converter] which converts requests
/// according to `application/cbor` content type.
class CborSerializableConverter implements Converter {
  static const headerKey = 'Content-Type';
  static const headerValue = 'application/cbor';

  @override
  FutureOr<Request> convertRequest(Request request) {
    return applyHeader(request, headerKey, headerValue);
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    return response as Response<BodyType>;
  }
}
