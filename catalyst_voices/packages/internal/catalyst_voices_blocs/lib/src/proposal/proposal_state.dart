import 'package:catalyst_voices_blocs/src/comments/comments_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalState extends Equatable {
  final bool isLoading;
  final ProposalViewData data;
  final CommentsState comments;
  final LocalizedException? error;

  const ProposalState({
    this.isLoading = false,
    this.data = const ProposalViewData(),
    this.comments = const CommentsState(),
    this.error,
  });

  @override
  List<Object?> get props => [
        isLoading,
        data,
        comments,
        error,
      ];

  bool get showData => !showError;

  bool get showError => !isLoading && error != null;

  ProposalState copyWith({
    bool? isLoading,
    ProposalViewData? data,
    CommentsState? comments,
    Optional<LocalizedException>? error,
  }) {
    return ProposalState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      comments: comments ?? this.comments,
      error: error.dataOr(this.error),
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
