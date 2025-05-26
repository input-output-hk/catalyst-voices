import 'package:equatable/equatable.dart';

final class EmailAlreadyUsedException extends Equatable implements Exception {
  const EmailAlreadyUsedException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'EmailAlreadyUsedException';
}
