import 'package:equatable/equatable.dart';

final class ForbiddenException extends Equatable implements Exception {
  final String? message;

  const ForbiddenException({this.message});

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    if (message != null) {
      return 'ForbiddenException: $message';
    }
    return 'ForbiddenException';
  }
}
