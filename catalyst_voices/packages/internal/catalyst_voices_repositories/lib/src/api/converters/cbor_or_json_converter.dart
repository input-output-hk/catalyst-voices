import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

/// A [Converter] which maintains a set of hardcoded [_cborRequests]
/// to decide between cbor/json content converters.
///
/// The swagger_dart_code_generator package incorrectly generates
/// request handlers for application/cbor requests therefore we are
/// mapping out these requests to a proper converter type.
class CborOrJsonDelegateConverter implements Converter {
  static const _cborRequests = [
    (method: 'PUT', path: '/api/v1/document'),
  ];

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
    final request = response.base.request;
    if (request == null) {
      return response as Response<BodyType>;
    } else if (_isCborRequest(request)) {
      return cborConverter.convertResponse<BodyType, InnerType>(response);
    } else {
      return jsonConverter.convertResponse<BodyType, InnerType>(response);
    }
  }

  bool _isCborRequest(http.BaseRequest request) {
    for (final cborRequest in _cborRequests) {
      if (cborRequest.method.equalsIgnoreCase(request.method) &&
          cborRequest.path.equalsIgnoreCase(request.url.path)) {
        return true;
      }
    }

    return false;
  }
}
