import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const _publishActions = [
  ProposalMenuItemAction.publish,
  ProposalMenuItemAction.submit,
];

/// Menu item data for proposal builder publishing actions
final class ProposalBuilderMenuItemData extends Equatable {
  final ProposalMenuItemAction action;
  final String? proposalTitle;
  final int currentIteration;
  final bool canPublish;

  const ProposalBuilderMenuItemData({
    required this.action,
    required this.proposalTitle,
    required this.currentIteration,
    required this.canPublish,
  });

  bool get hasError {
    return !canPublish && _publishActions.contains(action);
  }

  @override
  List<Object?> get props => [
        action,
        proposalTitle,
        currentIteration,
        canPublish,
      ];

  String? description(BuildContext context) {
    return action.description(context, currentIteration: currentIteration);
  }

  String title(BuildContext context) {
    return action.title(context, proposalTitle, currentIteration);
  }
}
