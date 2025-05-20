import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/error/error_response.dart';
import 'package:chopper/chopper.dart' as chopper;

/// Handles [Future] API responses.
extension FutureResponseMapper<T> on Future<chopper.Response<T>> {
  Future<Uint8List> successBodyBytesOrThrow() async {
    final response = await this;
    return response.successBodyBytesOrThrow();
  }

  Future<T> successBodyOrThrow() async {
    final response = await this;
    return response.successBodyOrThrow();
  }
}

/// Handles API responses.
extension ResponseMapper<T> on chopper.Response<T> {
  Uint8List successBodyBytesOrThrow() {
    if (isSuccessful) {
      return bodyBytes;
    } else if (statusCode == ApiErrorResponseException.notFound) {
      throw NotFoundException(message: error.toString());
    } else if (statusCode == ApiErrorResponseException.conflict) {
      throw ResourceConflictException(message: _extractErrorMessage(error));
    } else {
      throw toApiException();
    }
  }

  T successBodyOrThrow() {
    if (isSuccessful) {
      return bodyOrThrow;
    } else if (statusCode == ApiErrorResponseException.notFound) {
      throw NotFoundException(message: _extractErrorMessage(error));
    } else if (statusCode == ApiErrorResponseException.conflict) {
      throw ResourceConflictException(message: _extractErrorMessage(error));
    } else {
      throw toApiException();
    }
  }

  ApiErrorResponseException toApiException() {
    return ApiErrorResponseException(
      statusCode: statusCode,
      error: error,
    );
  }

  String? _extractErrorMessage(Object? error) {
    if (error == null) return null;

    if (error is String) {
      return _extractErrorMessageFromJson(error) ?? error;
    }

    return error.toString();
  }

  String? _extractErrorMessageFromJson(String string) {
    try {
      final data = jsonDecode(string) as Map<String, dynamic>;
      final response = ErrorResponse.fromJson(data);
      return response.detail;
    } catch (error) {
      return null;
    }
  }
}
