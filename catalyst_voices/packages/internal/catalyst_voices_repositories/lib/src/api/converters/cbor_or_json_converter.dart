import 'dart:async';

import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

/// A [Converter] which decodes json/cbor depending on content-type header.
///
/// If the request does not have a content-type header
/// then the converter will fallback to json serialization.
///
/// The swagger_dart_code_generator package incorrectly generates
/// request handlers for application/cbor requests therefore we are
/// mapping out these requests to a proper converter type.
class CborOrJsonDelegateConverter implements Converter {
  final Converter cborConverter;
  final Converter jsonConverter;

  CborOrJsonDelegateConverter({
    required this.cborConverter,
    required this.jsonConverter,
  });

  @override
  FutureOr<Request> convertRequest(Request request) {
    if (_isCborRequest(request)) {
      return cborConverter.convertRequest(request);
    } else {
      return jsonConverter.convertRequest(request);
    }
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    if (_isCborResponse(response)) {
      return cborConverter.convertResponse<BodyType, InnerType>(response);
    } else {
      return jsonConverter.convertResponse<BodyType, InnerType>(response);
    }
  }

  bool _isCborContentType(Map<String, String> headers) {
    final lowercaseHeaders =
        headers.map((key, value) => MapEntry(key.toLowerCase(), value.toLowerCase()));
    final contentType = lowercaseHeaders[HttpHeaders.contentType.toLowerCase()];
    return contentType != null &&
        contentType.contains(ContentTypes.applicationCbor.toLowerCase());
  }

  bool _isCborRequest(http.BaseRequest request) {
    return _isCborContentType(request.headers);
  }

  bool _isCborResponse(Response<dynamic> response) {
    return _isCborContentType(response.headers);
  }
}
