import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalState extends Equatable {
  final ProposalViewHeader header;
  final List<ProposalBuilderSegment> segments;

  const ProposalState({
    this.header = const ProposalViewHeader(),
    this.segments = const [],
  });

  @override
  List<Object?> get props => [
        header,
        segments,
      ];
}
