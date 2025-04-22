import 'package:equatable/equatable.dart';

final class AccountEmail extends Equatable {
  final String email;
  final AccountEmailVerificationStatus status;

  const AccountEmail({
    required this.email,
    required this.status,
  });

  const AccountEmail.pending(this.email)
      : status = AccountEmailVerificationStatus.pending;

  const AccountEmail.unknown(this.email)
      : status = AccountEmailVerificationStatus.unknown;

  bool get isVerified => status == AccountEmailVerificationStatus.verified;

  @override
  List<Object?> get props => [email, status];

  AccountEmail copyWith({
    String? email,
    AccountEmailVerificationStatus? status,
  }) {
    return AccountEmail(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}

enum AccountEmailVerificationStatus {
  verified,
  pending,
  unknown;

  bool get isVerified => this == AccountEmailVerificationStatus.verified;
}
