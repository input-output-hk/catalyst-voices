import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Filters for querying representatives.
final class RepresentativesFilters extends Equatable {
  /// Filter by favorite status.
  final bool? isFavorite;

  /// Filter by campaign.
  final CampaignFilters? campaign;

  /// Filter by profile which represented account with [represented] but no longer do.
  final CatalystId? represented;

  const RepresentativesFilters({
    this.isFavorite,
    this.campaign,
    this.represented,
  });

  @override
  List<Object?> get props => [
    isFavorite,
    campaign,
    represented,
  ];

  RepresentativesFilters copyWith({
    Optional<bool>? isFavorite,
    Optional<CampaignFilters>? campaign,
    Optional<CatalystId>? represented,
  }) {
    return RepresentativesFilters(
      isFavorite: isFavorite.dataOr(this.isFavorite),
      campaign: campaign.dataOr(this.campaign),
      represented: represented.dataOr(this.represented),
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('RepresentativesFilters(');
    final parts = <String>[];

    if (isFavorite != null) {
      parts.add('isFavorite: $isFavorite');
    }
    if (campaign != null) {
      parts.add('campaign: $campaign');
    }
    if (represented != null) {
      parts.add('represented: $represented');
    }

    buffer
      ..write(parts.isNotEmpty ? parts.join(', ') : 'no filters')
      ..write(')');

    return buffer.toString();
  }
}
