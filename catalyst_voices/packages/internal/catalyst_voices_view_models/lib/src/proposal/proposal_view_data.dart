import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// View model representing proposal in a view mode
final class ProposalViewData extends DocumentViewerData {
  final bool? isCurrentVersionLatest;
  final String? categoryText;

  const ProposalViewData({
    this.isCurrentVersionLatest,
    ProposalViewHeader super.header = const ProposalViewHeader(),
    super.segments = const [],
    this.categoryText,
  });

  /// Returns the header typed as ProposalViewHeader
  @override
  ProposalViewHeader get header => super.header as ProposalViewHeader;

  @override
  List<Object?> get props => [
    ...super.props,
    isCurrentVersionLatest,
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
