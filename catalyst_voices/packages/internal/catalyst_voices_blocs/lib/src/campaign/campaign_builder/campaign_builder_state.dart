part of 'campaign_builder_cubit.dart';

final class CampaignBuilderState extends Equatable {
  final bool isLoading;
  final CampaignPublish? publish;
  final DateTime? startDate;
  final DateTime? endDate;

  const CampaignBuilderState({
    this.isLoading = false,
    this.publish,
    this.startDate,
    this.endDate,
  });

  CampaignBuilderState copyWith({
    bool? isLoading,
    Optional<CampaignPublish>? publish,
    Optional<DateTime>? startDate,
    Optional<DateTime>? endDate,
  }) {
    return CampaignBuilderState(
      isLoading: isLoading ?? this.isLoading,
      publish: publish.dataOr(this.publish),
      startDate: startDate.dataOr(this.startDate),
      endDate: endDate.dataOr(this.endDate),
    );
  }

  @override
  List<Object?> get props => [isLoading, publish, startDate, endDate];
}
