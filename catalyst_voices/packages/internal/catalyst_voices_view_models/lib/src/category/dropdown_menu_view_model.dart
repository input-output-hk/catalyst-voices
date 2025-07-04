import 'package:equatable/equatable.dart';

/// Represent a dropdown menu item. Used in conjunction with any widget that has a dropdown menu behavior.
class DropdownMenuViewModel<T extends Object> extends Equatable {
  final T? value;
  final String name;
  final bool isSelected;

  const DropdownMenuViewModel({
    required this.value,
    required this.name,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [
        value,
        name,
        isSelected,
      ];
}

extension ListDropdownMenuViewModelExt on List<DropdownMenuViewModel> {
  String get selectedName => firstWhere((e) => e.isSelected).name;
}
