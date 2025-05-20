import 'package:equatable/equatable.dart';

final class ResourceConflictException extends Equatable implements Exception {
  final String? message;

  const ResourceConflictException({this.message});

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    if (message != null) {
      return 'ResourceConflictException: $message';
    }
    return 'ResourceConflictException';
  }
}
