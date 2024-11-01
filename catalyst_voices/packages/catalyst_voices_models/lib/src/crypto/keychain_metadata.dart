import 'package:equatable/equatable.dart';

// TODO(damian-molinski): Migrate serialization to json_serializable.
final class KeychainMetadata extends Equatable {
  final DateTime createdAt;
  final DateTime updatedAt;

  const KeychainMetadata({
    required this.createdAt,
    required this.updatedAt,
  });

  factory KeychainMetadata.fromJson(Map<String, dynamic> json) {
    // Typo migration
    if (!json.containsKey('createdAt') && json.containsKey('createAt')) {
      json['createdAt'] = json['createAt'];
    }
    return KeychainMetadata(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  KeychainMetadata copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KeychainMetadata(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        createdAt,
        updatedAt,
      ];
}
