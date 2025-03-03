import 'dart:typed_data';

import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ImportProposalEvent extends WorkspaceEvent {
  final Uint8List proposalData;

  const ImportProposalEvent(this.proposalData);

  @override
  List<Object?> get props => proposalData;
}

final class LoadProposalsEvent extends WorkspaceEvent {
  const LoadProposalsEvent();

  @override
  List<Object?> get props => [];
}

final class SearchQueryChangedEvent extends WorkspaceEvent {
  final String query;
  final bool isSubmitted;

  const SearchQueryChangedEvent(
    this.query, {
    this.isSubmitted = false,
  });

  @override
  List<Object?> get props => [
        query,
        isSubmitted,
      ];
}

final class TabChangedEvent extends WorkspaceEvent {
  final WorkspaceTabType tab;

  const TabChangedEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

sealed class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();
}
