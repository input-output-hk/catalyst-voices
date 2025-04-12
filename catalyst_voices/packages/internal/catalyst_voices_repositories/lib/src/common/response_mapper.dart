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
    if (!isSuccessful) {
      throw toApiException();
    }
  }
}
