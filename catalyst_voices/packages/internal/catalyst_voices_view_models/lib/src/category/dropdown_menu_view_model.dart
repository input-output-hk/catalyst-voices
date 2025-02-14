import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:equatable/equatable.dart';

class DropdownMenuViewModel extends Equatable {
  final String? value;
  final String name;
  final bool isSelected;

  const DropdownMenuViewModel({
    required this.value,
    required this.name,
    required this.isSelected,
  });

  factory DropdownMenuViewModel.all(
    VoicesLocalizations l10n, {
    required bool isSelected,
  }) {
    return DropdownMenuViewModel(
      value: null,
      name: l10n.showAll,
      isSelected: isSelected,
    );
  }

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
