import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Single item representing proposal category in a category selector (dropdown menu)
final class ProposalsCategorySelectorItem extends Equatable {
  final SignedDocumentRef ref;
  final String name;
  final bool isSelected;

  const ProposalsCategorySelectorItem({
    required this.ref,
    required this.name,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [ref, name, isSelected];

  ProposalsCategorySelectorItem copyWith({
    SignedDocumentRef? ref,
    String? name,
    bool? isSelected,
  }) {
    return ProposalsCategorySelectorItem(
      ref: ref ?? this.ref,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
