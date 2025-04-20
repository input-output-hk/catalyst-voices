import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:chopper/chopper.dart';

/// Handles API responses.
extension ResponseMapper on Response<dynamic> {
  ApiErrorResponseException toApiException() {
    return ApiErrorResponseException(
      statusCode: statusCode,
      error: error,
    );
  }

  void verifyIsSuccessful() {
    if (isSuccessful) {
      return;
    } else if (statusCode == ApiErrorResponseException.notFound) {
      throw NotFoundException(message: error.toString());
    } else {
      throw toApiException();
    }
  }
}
