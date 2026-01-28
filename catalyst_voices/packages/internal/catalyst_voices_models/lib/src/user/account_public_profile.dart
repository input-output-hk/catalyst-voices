import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AccountPublicProfile extends Equatable {
  final String email;
  final String? username;
  final AccountPublicStatus status;
  final AccountPublicRbacStatus rbacRegStatus;

  const AccountPublicProfile({
    required this.email,
    this.username,
    this.status = AccountPublicStatus.unknown,
    this.rbacRegStatus = AccountPublicRbacStatus.unknown,
  });

  AccountPublicProfile.fromAccountUnknown(Account account)
    : this(
        email: account.email ?? '',
        username: account.username,
      );

  @override
  List<Object?> get props => [
    email,
    username,
    status,
    rbacRegStatus,
  ];
}
