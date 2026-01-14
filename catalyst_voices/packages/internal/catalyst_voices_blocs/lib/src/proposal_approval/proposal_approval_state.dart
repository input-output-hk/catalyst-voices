import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalApprovalState extends Equatable {
  final ProposalApprovalTabType selectedTab;
  final List<UsersProposalOverview> items;

  const ProposalApprovalState({
    this.selectedTab = ProposalApprovalTabType.decide,
    this.items = const [],
  });

  List<UsersProposalOverview> get decideItems => items;

  List<UsersProposalOverview> get finalItems => items;

  @override
  List<Object?> get props => [selectedTab, items];

  ProposalApprovalState copyWith({
    ProposalApprovalTabType? selectedTab,
    List<UsersProposalOverview>? items,
  }) {
    return ProposalApprovalState(
      selectedTab: selectedTab ?? this.selectedTab,
      items: items ?? this.items,
    );
  }
}
