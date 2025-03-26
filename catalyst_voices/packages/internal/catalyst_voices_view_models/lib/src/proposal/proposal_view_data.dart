import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewData extends Equatable {
  final bool? isCurrentVersionLatest;
  final ProposalViewHeader header;
  final List<Segment> segments;
  final ProposalCommentsSort commentsSort;
  final Map<DocumentRef, bool> showReplies;
  final Map<DocumentRef, bool> showReplyBuilder;

  const ProposalViewData({
    this.isCurrentVersionLatest,
    this.header = const ProposalViewHeader(),
    this.segments = const [],
    this.commentsSort = ProposalCommentsSort.newest,
    this.showReplies = const {},
    this.showReplyBuilder = const {},
  });

  @override
  List<Object?> get props => [
        isCurrentVersionLatest,
        header,
        segments,
        commentsSort,
        showReplies,
        showReplyBuilder,
      ];

  ProposalViewData copyWith({
    Optional<bool>? isCurrentVersionLatest,
    ProposalViewHeader? header,
    List<Segment>? segments,
    ProposalCommentsSort? commentsSort,
    Map<DocumentRef, bool>? showReplies,
    Map<DocumentRef, bool>? showReplyBuilder,
  }) {
    return ProposalViewData(
      isCurrentVersionLatest: isCurrentVersionLatest.dataOr(
        this.isCurrentVersionLatest,
      ),
      header: header ?? this.header,
      segments: segments ?? this.segments,
      commentsSort: commentsSort ?? this.commentsSort,
      showReplies: showReplies ?? this.showReplies,
      showReplyBuilder: showReplyBuilder ?? this.showReplyBuilder,
    );
  }
}
