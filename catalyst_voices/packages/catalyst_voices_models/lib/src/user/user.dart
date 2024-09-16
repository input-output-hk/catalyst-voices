import 'package:equatable/equatable.dart';

/// Defines the profile of the app user.
final class User extends Equatable {
  final String name;

  const User({required this.name});

  @override
  List<Object?> get props => [name];
}
