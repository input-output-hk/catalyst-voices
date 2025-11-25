import 'package:catalyst_voices_blocs/src/comments/comments_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalState extends Equatable {
  final bool isLoading;
  final ProposalViewData data;
  final CommentsState comments;
  final CollaboratorInvitationState invitation;
  final LocalizedException? error;
  final bool readOnlyMode;

  const ProposalState({
    this.isLoading = false,
    this.data = const ProposalViewData(),
    this.comments = const CommentsState(),
    this.invitation = const CollaboratorInvitationState(),
    this.error,
    this.readOnlyMode = false,
  });

  @override
  List<Object?> get props => [
    isLoading,
    data,
    comments,
    invitation,
    error,
    readOnlyMode,
  ];

  bool get showData => !showError;

  bool get showError => !isLoading && error != null;

  bool get showInvitation => !invitation.isDismissed && invitation.invitation != null;

  ProposalState copyWith({
    bool? isLoading,
    ProposalViewData? data,
    CommentsState? comments,
    CollaboratorInvitationState? invitation,
    Optional<LocalizedException>? error,
    bool? readOnlyMode,
  }) {
    return ProposalState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      comments: comments ?? this.comments,
      invitation: invitation ?? this.invitation,
      error: error.dataOr(this.error),
      readOnlyMode: readOnlyMode ?? this.readOnlyMode,
    );
  }

  ProposalState copyWithFavorite({
    required bool isFavorite,
  }) {
    final updatedHeader = data.header.copyWith(isFavorite: isFavorite);
    final updatedData = data.copyWith(header: updatedHeader);
    return copyWith(data: updatedData);
  }
}
