import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:chopper/chopper.dart' as chopper;

/// Handles [Future] API responses.
extension FutureResponseMapper<T> on Future<chopper.Response<T>> {
  /// Returns [Uint8List] body bytes from the response
  /// or throws an exception if the response wasn't successful.
  Future<Uint8List> successBodyBytesOrThrow() async {
    final response = await this;
    return response.successBodyBytesOrThrow();
  }

  /// Returns the [T] body from the response
  /// or throws an exception if the response wasn't successful.
  Future<T> successBodyOrThrow() async {
    final response = await this;
    return response.successBodyOrThrow();
  }

  /// Completes successfully if the response was successful
  /// or throws an exception if it wasn't.
  Future<void> successOrThrow() async {
    final response = await this;
    return response.successOrThrow();
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
    } else if (statusCode == ApiErrorResponseException.unauthorized) {
      throw UnauthorizedException(message: error.toString());
    } else if (statusCode == ApiErrorResponseException.conflict) {
      throw ResourceConflictException(message: _extractErrorMessage(error));
    } else {
      throw toApiException();
    }
  }

  void successOrThrow() {
    if (isSuccessful) {
      return;
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
    return error?.toString();
  }
}
