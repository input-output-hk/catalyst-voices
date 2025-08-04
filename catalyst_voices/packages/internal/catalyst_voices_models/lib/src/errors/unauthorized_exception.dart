import 'package:equatable/equatable.dart';

final class UnauthorizedException extends Equatable implements Exception {
  final String? message;

  const UnauthorizedException({this.message});

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    if (message != null) {
      return 'UnauthorizedException: $message';
    }
    return 'UnauthorizedException';
  }
}
