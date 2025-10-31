import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Defines well-known status codes.
///
/// See [ApiBadResponseException].
abstract class ApiResponseStatusCode {
  /// The client has not sent valid request, could be an invalid HTTP in
  /// general or provided not correct headers, path or query arguments.
  static const int badRequest = 400;

  /// The client has not sent valid authentication credentials for the
  /// requested resource.
  static const int unauthorized = 401;

  /// The client has not sent valid authentication credentials for the
  /// requested resource.
  static const int forbidden = 403;

  /// In context of request.
  static const int notFound = 404;

  /// A request could not be completed due to a conflict
  /// with the current state of the target resource.
  static const int conflict = 409;

  /// The client has not sent valid data in its request, headers, parameters
  /// or body.
  static const int preconditionFailed = 412;

  /// The client sent a request with the URI is longer than the server is
  /// willing to interpret
  static const int uriTooLong = 414;

  /// The client has sent too many requests in a given amount of time.
  static const int tooManyRequests = 429;

  /// The client sent a request with too large header fields.
  static const int requestHeaderFieldsTooLarge = 431;

  /// An internal server error occurred.
  ///
  /// The contents of this response should be reported to the projects
  /// issue tracker.
  static const int internalServerError = 500;

  /// The service is not available, try again later.
  ///
  /// This is returned when the service either has not started, or has become
  /// unavailable.
  static const int serviceUnavailable = 503;

  const ApiResponseStatusCode._();
}
