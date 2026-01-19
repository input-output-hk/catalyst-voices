part of 'api_exception.dart';

final class ApiReceiveTimeoutException extends ApiException {
  final Duration? duration;

  const ApiReceiveTimeoutException({
    super.message,
    super.uri,
    super.error,
    this.duration,
  });

  @override
  List<Object?> get props => super.props + [duration];
}
