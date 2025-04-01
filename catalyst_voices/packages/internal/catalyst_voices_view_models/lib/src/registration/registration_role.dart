import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

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
