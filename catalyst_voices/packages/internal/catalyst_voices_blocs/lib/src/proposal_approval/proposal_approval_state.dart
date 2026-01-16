import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalApprovalState extends Equatable {
  final ProposalApprovalTabType selectedTab;
  final CatalystId? activeAccountId;
  final List<UsersProposalOverview> decideItems;
  final List<UsersProposalOverview> finalItems;

  const ProposalApprovalState({
    this.selectedTab = ProposalApprovalTabType.decide,
    this.activeAccountId,
    this.decideItems = const [],
    this.finalItems = const [],
  });

  @override
  List<Object?> get props => [selectedTab, activeAccountId, decideItems, finalItems];

  ProposalApprovalState copyWith({
    ProposalApprovalTabType? selectedTab,
    Optional<CatalystId>? activeAccountId,
    List<UsersProposalOverview>? decideItems,
    List<UsersProposalOverview>? finalItems,
  }) {
    return ProposalApprovalState(
      selectedTab: selectedTab ?? this.selectedTab,
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      decideItems: decideItems ?? this.decideItems,
      finalItems: finalItems ?? this.finalItems,
    );
  }
}
