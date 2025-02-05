import 'package:equatable/equatable.dart';

abstract interface class MenuItem {
  String get id;

  String get label;

  bool get isEnabled;
}

base class BasicMenuItem extends Equatable implements MenuItem {
  @override
  final String id;
  @override
  final String label;
  @override
  final bool isEnabled;

  const BasicMenuItem({
    required this.id,
    required this.label,
    this.isEnabled = true,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        isEnabled,
      ];
}
