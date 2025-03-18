import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewData extends Equatable {
  final bool? isCurrentVersionLatest;
  final ProposalViewHeader header;
  final List<Segment> segments;
  final ProposalCommentsSort commentsSort;

  const ProposalViewData({
    this.isCurrentVersionLatest,
    this.header = const ProposalViewHeader(),
    this.segments = const [],
    this.commentsSort = ProposalCommentsSort.newest,
  });

  @override
  List<Object?> get props => [
        isCurrentVersionLatest,
        header,
        segments,
        commentsSort,
      ];

  ProposalViewData addComment(CommentDocument comment) {
    final segments = List.of(this.segments)
        .map((segment) {
          return segment is ProposalCommentsSegment
              ? segment.addComment(comment)
              : segment;
        })
        .sortWith(sort: commentsSort)
        .toList();

    return copyWith(segments: segments);
  }

  ProposalViewData copyWith({
    Optional<bool>? isCurrentVersionLatest,
    ProposalViewHeader? header,
    List<Segment>? segments,
    ProposalCommentsSort? commentsSort,
  }) {
    return ProposalViewData(
      isCurrentVersionLatest: isCurrentVersionLatest.dataOr(
        this.isCurrentVersionLatest,
      ),
      header: header ?? this.header,
      segments: segments ?? this.segments,
      commentsSort: commentsSort ?? this.commentsSort,
    );
  }
}
