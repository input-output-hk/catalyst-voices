import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'api_bad_certificate_exception.dart';
part 'api_bad_response_exception.dart';
part 'api_connection_error_exception.dart';
part 'api_connection_timeout_exception.dart';
part 'api_malformed_body_exception.dart';
part 'api_receive_timeout_exception.dart';
part 'api_request_cancelled_exception.dart';
part 'api_send_timeout_exception.dart';
part 'api_unknown_exception.dart';

/// Specialized [Exception] for cases when API returns response but it's not successful or
/// invalid for any reason.
///
/// If maybe used when response body does not match what we're expecting.
sealed class ApiException extends Equatable implements Exception {
  /// Optional human readable message.
  final String? message;

  /// Request URI associated with the failure when available.
  final Uri? uri;

  /// Underlying error of the failure if present.
  final Object? error;

  const ApiException({
    this.message,
    this.uri,
    this.error,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [message, uri, error];
}
