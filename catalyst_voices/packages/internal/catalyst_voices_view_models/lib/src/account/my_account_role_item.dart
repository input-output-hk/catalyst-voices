import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

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
