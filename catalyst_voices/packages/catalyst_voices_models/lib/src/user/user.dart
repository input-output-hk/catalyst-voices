import 'package:equatable/equatable.dart';

/// Defines the profile of the app user.
final class User extends Equatable {
  final String name;

  const User({
    required this.name,
  });

  String? get acronym {
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : null;
  }

  @override
  List<Object?> get props => [name];
}
