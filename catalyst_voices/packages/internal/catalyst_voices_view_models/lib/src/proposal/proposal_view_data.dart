import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewData extends Equatable {
  final ProposalViewHeader header;
  final List<Segment> segments;
  final NodeId? activeNodeId;

  const ProposalViewData({
    this.header = const ProposalViewHeader(),
    this.segments = const [],
    this.activeNodeId,
  });

  @override
  List<Object?> get props => [
        header,
        segments,
        activeNodeId,
      ];

  ProposalViewData copyWith({
    ProposalViewHeader? header,
    List<Segment>? segments,
    Optional<NodeId>? activeNodeId,
  }) {
    return ProposalViewData(
      header: header ?? this.header,
      segments: segments ?? this.segments,
      activeNodeId: activeNodeId.dataOr(this.activeNodeId),
    );
  }
}
