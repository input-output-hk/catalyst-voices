import 'dart:async';

import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:chopper/chopper.dart';

/// A [Converter] which converts requests
/// according to `application/cbor` content type.
class CborSerializableConverter implements Converter {
  @override
  FutureOr<Request> convertRequest(Request request) {
    return applyHeader(
      request,
      HttpHeaders.contentType,
      ContentTypes.applicationCbor,
    );
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    return response as Response<BodyType>;
  }
}
