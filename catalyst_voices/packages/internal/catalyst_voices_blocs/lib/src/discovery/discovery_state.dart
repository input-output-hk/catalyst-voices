part of 'discovery_cubit.dart';

final class DiscoveryState extends Equatable {
  final DiscoveryCurrentCampaignState currentCampaign;

  const DiscoveryState({
    this.currentCampaign = const DiscoveryCurrentCampaignState(),
  });

  DiscoveryState copyWith({
    DiscoveryCurrentCampaignState? currentCampaign,
  }) {
    return DiscoveryState(
      currentCampaign: currentCampaign ?? this.currentCampaign,
    );
  }

  @override
  List<Object?> get props => [
        currentCampaign,
      ];
}

final class DiscoveryCurrentCampaignState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final CurrentCampaignInfoViewModel currentCampaign;

  const DiscoveryCurrentCampaignState({
    this.isLoading = true,
    this.error,
    CurrentCampaignInfoViewModel? currentCampaign,
  }) : currentCampaign =
            currentCampaign ?? const NullCurrentCampaignInfoViewModel();

  bool get showCurrentCampaign =>
      !isLoading && currentCampaign is! NullCurrentCampaignInfoViewModel;

  bool get showError => !isLoading && error != null;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        currentCampaign,
      ];
}
