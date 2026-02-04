import 'package:equatable/equatable.dart';

final class AccountInvitesApprovalsCount extends Equatable {
  final int invitesCount;
  final int approvalsCount;

  const AccountInvitesApprovalsCount({required this.invitesCount, required this.approvalsCount});

  bool get hasActions => totalCount > 0;

  @override
  List<Object?> get props => [invitesCount, approvalsCount];

  int get totalCount => invitesCount + approvalsCount;
}
