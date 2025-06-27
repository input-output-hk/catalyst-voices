import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

part 'api_error_response_exception.dart';
part 'api_malformed_body_exception.dart';

/// Specialized [Exception] for cases when API returns response but it's not successful or
/// invalid for any reason.
///
/// If maybe used when response body does not match what we're expecting.
///
/// See:
///   - [ApiErrorResponseException]
///   - [ApiMalformedBodyException]
sealed class ApiException extends Equatable implements Exception {
  const ApiException();
}
