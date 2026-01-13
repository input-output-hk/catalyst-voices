import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalApprovalState extends Equatable {
  final ProposalApprovalTabType selectedTab;

  final List<CollaboratorProposalDisplayConsent> items;

  const ProposalApprovalState({
    this.selectedTab = ProposalApprovalTabType.decide,
    this.items = const [],
  });

  int get decideCount => 0;

  int get finalCount => 0;

  @override
  List<Object?> get props => [selectedTab, items];

  ProposalApprovalState copyWith({
    ProposalApprovalTabType? selectedTab,
    List<CollaboratorProposalDisplayConsent>? items,
  }) {
    return ProposalApprovalState(
      selectedTab: selectedTab ?? this.selectedTab,
      items: items ?? this.items,
    );
  }
}
