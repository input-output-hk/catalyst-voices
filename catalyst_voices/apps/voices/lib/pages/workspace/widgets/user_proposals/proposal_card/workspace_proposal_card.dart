import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/proposal_menu_action_button.dart';
import 'package:catalyst_voices/pages/workspace/widgets/user_proposal_invites/review_request_button.dart';
import 'package:catalyst_voices/widgets/cards/proposal/proposal_card_widgets.dart';
import 'package:catalyst_voices/widgets/cards/proposal_iteration_history_card.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/text/last_edit_date.dart';
import 'package:catalyst_voices/widgets/user/catalyst_id_text.dart';
import 'package:catalyst_voices/widgets/user/username_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'workspace_proposal_card_components.dart';
part 'workspace_proposal_card_responsiveness.dart';

class WorkspaceProposalCard extends StatelessWidget {
  final UsersProposalOverview proposal;
  final WorkspaceProposalType type;

  const WorkspaceProposalCard({
    super.key,
    required this.proposal,
    this.type = WorkspaceProposalType.proposal,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitted = proposal.publish.isPublished;

    return _ProposalSubmitState(
      isSubmitted: isSubmitted,
      type: type,
      child: _WorkspaceProposalCard(
        type: type,
        proposal: proposal,
      ),
    );
  }
}

enum WorkspaceProposalType {
  proposal,
  invite;

  const WorkspaceProposalType();

  bool get isInvite => this == invite;
  bool get isProposal => this == proposal;
}

class _ActionButton extends StatelessWidget {
  final UsersProposalOverview proposal;
  final WorkspaceProposalType type;

  const _ActionButton({
    required this.proposal,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      WorkspaceProposalType.proposal => ProposalMenuActionButton(
        ref: proposal.id,
        proposalPublish: proposal.publish,
        title: proposal.title,
        version: proposal.iteration,
        hasNewerLocalIteration: proposal.hasNewerLocalIteration,
        fromActiveCampaign: proposal.fromActiveCampaign,
        ownership: proposal.ownership,
      ),
      WorkspaceProposalType.invite => ReviewRequestButton(id: proposal.id),
    };
  }
}

class _Body extends StatelessWidget {
  final UsersProposalOverview proposal;
  final WorkspaceProposalType type;

  const _Body(this.proposal, this.type);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _WorkspaceProposalCardResponsiveness(
            proposal,
            type: type,
          ),
        ),
        _ActionButton(
          proposal: proposal,
          type: type,
        ),
      ],
    );
  }
}

class _ProposalSubmitState extends InheritedWidget {
  final bool isSubmitted;
  final WorkspaceProposalType type;

  const _ProposalSubmitState({
    required super.child,
    required this.isSubmitted,
    required this.type,
  });

  Color backgroundColor(BuildContext context) => isSubmitted && type.isProposal
      ? context.colors.iconsPrimary
      : context.colors.elevationsOnSurfaceNeutralLv1White;

  Color dataLabelColor(BuildContext context) => isSubmitted && type.isProposal
      ? context.colors.primaryContainer
      : context.colors.textOnPrimaryLevel1;

  Color headerColor(BuildContext context) => isSubmitted && type.isProposal
      ? context.colors.textOnPrimaryWhite
      : context.colors.textOnPrimaryLevel0;

  Color headerLabelColor(BuildContext context) => isSubmitted && type.isProposal
      ? context.colors.textOnPrimaryWhite
      : context.colors.textOnPrimaryLevel1;

  @override
  bool updateShouldNotify(_ProposalSubmitState oldWidget) {
    return oldWidget.isSubmitted != isSubmitted || oldWidget.type != type;
  }

  static _ProposalSubmitState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ProposalSubmitState>();
  }
}

class _WorkspaceProposalCard extends StatelessWidget {
  final WorkspaceProposalType type;
  final UsersProposalOverview proposal;

  const _WorkspaceProposalCard({
    required this.type,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _ProposalSubmitState.of(context)?.backgroundColor(context);
    final isPublishedDraft = proposal.publish.isDraft;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Body(proposal, type),
            if (isPublishedDraft && proposal.versions.length >= 2 && !type.isInvite)
              ProposalIterationHistory(
                proposal: proposal,
              ),
          ],
        ),
      ),
    );
  }
}
