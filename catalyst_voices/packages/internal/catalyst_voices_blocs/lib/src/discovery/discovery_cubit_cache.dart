import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DiscoveryCubitCache extends Equatable {
  final Campaign? activeCampaign;

  const DiscoveryCubitCache({
    this.activeCampaign,
  });

  @override
  List<Object?> get props => [activeCampaign];

  DiscoveryCubitCache copyWith({
    Optional<Campaign>? activeCampaign,
  }) {
    return DiscoveryCubitCache(
      activeCampaign: activeCampaign.dataOr(this.activeCampaign),
    );
  }
}
