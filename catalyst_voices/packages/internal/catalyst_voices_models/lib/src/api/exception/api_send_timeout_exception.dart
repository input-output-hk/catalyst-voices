part of 'api_exception.dart';

final class ApiSendTimeoutException extends ApiException {
  final Duration? duration;

  const ApiSendTimeoutException({
    super.message,
    super.uri,
    super.error,
    this.duration,
  });

  @override
  List<Object?> get props => super.props + [duration];
}
