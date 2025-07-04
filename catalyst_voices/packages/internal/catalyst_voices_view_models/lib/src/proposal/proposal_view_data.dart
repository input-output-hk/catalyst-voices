import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// View model representing proposal in a view mode
final class ProposalViewData extends Equatable {
  final bool? isCurrentVersionLatest;
  final ProposalViewHeader header;
  final List<Segment> segments;

  const ProposalViewData({
    this.isCurrentVersionLatest,
    this.header = const ProposalViewHeader(),
    this.segments = const [],
  });

  @override
  List<Object?> get props => [
        isCurrentVersionLatest,
        header,
        segments,
      ];

  ProposalViewData copyWith({
    Optional<bool>? isCurrentVersionLatest,
    ProposalViewHeader? header,
    List<Segment>? segments,
  }) {
    return ProposalViewData(
      isCurrentVersionLatest: isCurrentVersionLatest.dataOr(
        this.isCurrentVersionLatest,
      ),
      header: header ?? this.header,
      segments: segments ?? this.segments,
    );
  }
}
