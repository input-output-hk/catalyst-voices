import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationTransactionRole extends Equatable {
  final AccountRole type;
  final RegistrationTransactionRoleAction action;

  const RegistrationTransactionRole.set(AccountRole type)
      : this._(
          type,
          RegistrationTransactionRoleAction.set,
        );

  const RegistrationTransactionRole.undefined(AccountRole type)
      : this._(
          type,
          RegistrationTransactionRoleAction.undefined,
        );

  const RegistrationTransactionRole.unset(AccountRole type)
      : this._(
          type,
          RegistrationTransactionRoleAction.unset,
        );

  const RegistrationTransactionRole._(this.type, this.action);

  @override
  List<Object?> get props => [type, action];

  bool get setDrep =>
      type == AccountRole.drep &&
      action == RegistrationTransactionRoleAction.set;

  bool get setProposer =>
      type == AccountRole.proposer &&
      action == RegistrationTransactionRoleAction.set;

  bool get setVoter =>
      type == AccountRole.voter &&
      action == RegistrationTransactionRoleAction.set;
}

enum RegistrationTransactionRoleAction {
  set,
  undefined,
  unset,
}
