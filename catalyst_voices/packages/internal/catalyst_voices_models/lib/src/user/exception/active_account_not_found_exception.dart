import 'package:equatable/equatable.dart';

final class ActiveAccountNotFoundException extends Equatable implements Exception {
  const ActiveAccountNotFoundException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'ActiveAccountNotFoundException';
}
