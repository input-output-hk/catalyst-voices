import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewData extends Equatable {
  final ProposalViewHeader header;
  final List<ProposalBuilderSegment> segments;

  const ProposalViewData({
    this.header = const ProposalViewHeader(),
    this.segments = const [],
  });

  @override
  List<Object?> get props => [header, segments];

  ProposalViewData copyWith({
    ProposalViewHeader? header,
    List<ProposalBuilderSegment>? segments,
  }) {
    return ProposalViewData(
      header: header ?? this.header,
      segments: segments ?? this.segments,
    );
  }
}
