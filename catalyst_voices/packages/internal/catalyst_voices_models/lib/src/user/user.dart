import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Defines user or the app.
@JsonSerializable()
final class User extends Equatable {
  final List<Account> accounts;
  final String? activeKeychainId;

  const User({
    required this.accounts,
    this.activeKeychainId,
  });

  const User.empty() : this(accounts: const []);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Account? get activeAccount {
    return accounts
        .singleWhereOrNull((account) => account.keychainId == activeKeychainId);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    List<Account>? accounts,
    Optional<String>? activeKeychainId,
  }) {
    return User(
      accounts: accounts ?? this.accounts,
      activeKeychainId: activeKeychainId.dataOr(this.activeKeychainId),
    );
  }

  @override
  List<Object?> get props => [
        accounts,
        activeKeychainId,
      ];
}
