import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RepresentativesFilters extends Equatable {
  final bool? isFavorite;
  final CampaignFilters? campaign;

  const RepresentativesFilters({
    this.isFavorite,
    this.campaign,
  });

  @override
  List<Object?> get props => [
    isFavorite,
    campaign,
  ];

  ProposalsFiltersV2 copyWith({
    Optional<bool>? isFavorite,
    Optional<CampaignFilters>? campaign,
  }) {
    return ProposalsFiltersV2(
      isFavorite: isFavorite.dataOr(this.isFavorite),
      campaign: campaign.dataOr(this.campaign),
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

    buffer
      ..write(parts.isNotEmpty ? parts.join(', ') : 'no filters')
      ..write(')');

    return buffer.toString();
  }
}
