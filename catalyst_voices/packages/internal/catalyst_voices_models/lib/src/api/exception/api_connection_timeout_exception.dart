part of 'api_exception.dart';

final class ApiConnectionTimeoutException extends ApiException {
  final Duration? duration;

  const ApiConnectionTimeoutException({
    super.message,
    super.uri,
    super.error,
    this.duration,
  });

  @override
  List<Object?> get props => super.props + [duration];
}
