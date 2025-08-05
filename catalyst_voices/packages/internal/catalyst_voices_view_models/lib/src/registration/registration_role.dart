import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Represents a role in the registration process.
///
/// This is used to allow users to select a role when registering.
///
/// It contains the [type] of the account role and a boolean [isSelected]
/// indicating whether this role is currently selected.
///
/// It also contains a boolean [isLocked] indicating whether this role is locked and cannot be unselected.
final class RegistrationRole extends Equatable {
  final AccountRole type;
  final bool isSelected;
  final bool isLocked;

  const RegistrationRole({
    required this.type,
    this.isSelected = false,
    this.isLocked = false,
  });

  @override
  List<Object?> get props => [
        type,
        isSelected,
        isLocked,
      ];

  RegistrationRole copyWith({
    AccountRole? type,
    bool? isSelected,
    bool? isLocked,
  }) {
    return RegistrationRole(
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
