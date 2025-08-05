import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Single item representing proposal order in a dropdown menu
///
/// This is used in the proposals list to allow users to sort proposals
/// by different criteria, which are determined by the [ProposalsOrder] enum.
final class ProposalsDropdownOrderItem extends Equatable {
  final ProposalsOrder value;
  final bool isSelected;

  const ProposalsDropdownOrderItem(
    this.value, {
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [value, isSelected];

  ProposalsDropdownOrderItem copyWith({
    ProposalsOrder? value,
    bool? isSelected,
  }) {
    return ProposalsDropdownOrderItem(
      value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  String localizedName(BuildContext context) {
    return switch (value) {
      Alphabetical() => context.l10n.orderProposalsAlphabetical,
      Budget(:final isAscending) =>
        isAscending ? context.l10n.orderProposalsBudgetAsc : context.l10n.orderProposalsBudgetDesc,
      UpdateDate(:final isAscending) => isAscending
          ? context.l10n.orderProposalsUpdateDateAsc
          : context.l10n.orderProposalsUpdateDateDesc,
    };
  }
}
