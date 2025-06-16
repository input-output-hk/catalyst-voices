import 'dart:async';

import 'package:chopper/chopper.dart';

/// A [Converter] which converts requests
/// according to `application/cbor` content type.
class CborSerializableConverter implements Converter {
  static const contentTypeHeader = 'Content-Type';
  static const applicationCbor = 'application/cbor';

  @override
  FutureOr<Request> convertRequest(Request request) {
    return applyHeader(request, contentTypeHeader, applicationCbor);
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    return response as Response<BodyType>;
  }
}
