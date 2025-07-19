import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Represents a selectable account role for the current user.
///
/// This model is typically used to display and manage the selection state of different
/// account roles within the UI or business logic. It contains the [type] of the account role
/// and a boolean [isSelected] indicating whether this role is currently selected.
final class MyAccountRoleItem extends Equatable {
  final AccountRole type;
  final bool isSelected;

  const MyAccountRoleItem({
    required this.type,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [type, isSelected];
}
