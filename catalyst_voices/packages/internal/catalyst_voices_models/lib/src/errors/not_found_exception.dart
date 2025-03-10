import 'package:equatable/equatable.dart';

final class NotFoundException extends Equatable implements Exception {
  final String? message;

  const NotFoundException({this.message});

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    if (message != null) {
      return 'NotFoundException: $message';
    }
    return 'NotFoundException';
  }
}
