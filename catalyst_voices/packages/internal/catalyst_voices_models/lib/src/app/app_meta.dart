import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AppMeta extends Equatable {
  final DocumentRef? activeCampaign;
  final AppVersion? appVersion;

  const AppMeta({
    this.activeCampaign,
    this.appVersion,
  });

  @override
  List<Object?> get props => [
    activeCampaign,
    appVersion,
  ];

  AppMeta copyWith({
    Optional<DocumentRef>? activeCampaign,
    Optional<AppVersion>? appVersion,
  }) {
    return AppMeta(
      activeCampaign: activeCampaign.dataOr(this.activeCampaign),
      appVersion: appVersion.dataOr(this.appVersion),
    );
  }
}
