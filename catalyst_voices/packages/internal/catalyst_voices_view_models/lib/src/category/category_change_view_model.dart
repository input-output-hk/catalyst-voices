import 'package:equatable/equatable.dart';

class CategoryChangeViewModel extends Equatable {
  final String categoryId;
  final String name;
  final bool isSelected;

  const CategoryChangeViewModel({
    required this.categoryId,
    required this.name,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [
        categoryId,
        name,
        isSelected,
      ];
}
