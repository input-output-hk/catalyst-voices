import 'package:equatable/equatable.dart';

final class AccountRegistrationStatus extends Equatable {
  /// When account registration transaction is posted on chain it's not indexed right away.
  /// This means backend does not yet know about it because transaction was not picked up.
  final bool isIndexed;

  /// If account transaction is already persistent on chain or not.
  final bool isPersistent;

  const AccountRegistrationStatus({
    required this.isIndexed,
    required this.isPersistent,
  }) : assert(
         isPersistent && isIndexed || !isPersistent,
         'Account can be persistent only if already indexed',
       );

  const AccountRegistrationStatus.indexed({this.isPersistent = false}) : isIndexed = true;

  const AccountRegistrationStatus.notIndexed() : this(isIndexed: false, isPersistent: false);

  @override
  List<Object?> get props => [isIndexed, isPersistent];

  AccountRegistrationStatus copyWith({
    bool? isIndexed,
    bool? isPersistent,
  }) {
    return AccountRegistrationStatus(
      isIndexed: isIndexed ?? this.isIndexed,
      isPersistent: isPersistent ?? this.isPersistent,
    );
  }
}
