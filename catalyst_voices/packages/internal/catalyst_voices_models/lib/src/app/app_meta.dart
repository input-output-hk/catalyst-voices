import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AppMeta extends Equatable {
  final DocumentRef? activeCampaign;

  const AppMeta({
    this.activeCampaign,
  });

  @override
  List<Object?> get props => [
    activeCampaign,
  ];

  AppMeta copyWith({
    Optional<DocumentRef>? activeCampaign,
  }) {
    return AppMeta(
      activeCampaign: activeCampaign.dataOr(this.activeCampaign),
    );
  }
}
