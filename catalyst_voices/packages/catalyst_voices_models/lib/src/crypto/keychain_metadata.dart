import 'package:equatable/equatable.dart';

// TODO(damian-molinski): Migrate serialization to json_serializable.
final class KeychainMetadata extends Equatable {
  final DateTime createAt;
  final DateTime updatedAt;

  const KeychainMetadata({
    required this.createAt,
    required this.updatedAt,
  });

  factory KeychainMetadata.fromJson(Map<String, dynamic> json) {
    return KeychainMetadata(
      createAt: DateTime.parse(json['createAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  KeychainMetadata copyWith({
    DateTime? createAt,
    DateTime? updatedAt,
  }) {
    return KeychainMetadata(
      createAt: createAt ?? this.createAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createAt': createAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        createAt,
        updatedAt,
      ];
}
