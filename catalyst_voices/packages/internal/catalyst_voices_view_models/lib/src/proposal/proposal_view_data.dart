import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// View model representing proposal in a view mode
final class ProposalViewData extends Equatable {
  final bool? isCurrentVersionLatest;
  final ProposalViewHeader header;
  final List<Segment> segments;
  final String? categoryText;

  const ProposalViewData({
    this.isCurrentVersionLatest,
    this.header = const ProposalViewHeader(),
    this.segments = const [],
    this.categoryText,
  });

  @override
  List<Object?> get props => [
    isCurrentVersionLatest,
    header,
    segments,
    categoryText,
  ];

  ProposalViewData copyWith({
    Optional<bool>? isCurrentVersionLatest,
    ProposalViewHeader? header,
    List<Segment>? segments,
    Optional<String>? categoryText,
  }) {
    return ProposalViewData(
      isCurrentVersionLatest: isCurrentVersionLatest.dataOr(this.isCurrentVersionLatest),
      header: header ?? this.header,
      segments: segments ?? this.segments,
      categoryText: categoryText.dataOr(this.categoryText),
    );
  }
}
