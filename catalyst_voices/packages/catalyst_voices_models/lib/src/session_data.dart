import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class SessionData extends Equatable {
  final String email;
  final String password;

  const SessionData({
    required this.email,
    required this.password,
  });

  factory SessionData.fromJson(String source) => SessionData.fromMap(
        json.decode(
          source,
        ) as Map<String, Object>,
      );

  factory SessionData.fromMap(Map<String, Object> map) {
    return SessionData(
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [email, password];

  @override
  bool get stringify => true;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
