import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const _publishActions = [
  ProposalMenuItemAction.publish,
  ProposalMenuItemAction.submit,
];

typedef ProposalBuilderMenuColors = ({Color background, Color foreground});

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

  @override
  List<Object?> get props => [
        action,
        proposalTitle,
        currentIteration,
        canPublish,
      ];

  ProposalBuilderMenuColors? colors(BuildContext context) {
    if (!canPublish && _publishActions.contains(action)) {
      return (
        background: Theme.of(context).colorScheme.errorContainer,
        foreground: Theme.of(context).colorScheme.onErrorContainer,
      );
    }

    return null;
  }

  String? description(BuildContext context) {
    return action.description(context, currentIteration: currentIteration);
  }

  String title(BuildContext context) {
    return action.title(context, proposalTitle, currentIteration);
  }
}
