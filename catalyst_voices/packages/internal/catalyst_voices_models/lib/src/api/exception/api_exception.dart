import 'package:equatable/equatable.dart';

part 'api_error_response_exception.dart';

/// Groups api related exceptions
sealed class ApiException extends Equatable implements Exception {
  const ApiException();
}
