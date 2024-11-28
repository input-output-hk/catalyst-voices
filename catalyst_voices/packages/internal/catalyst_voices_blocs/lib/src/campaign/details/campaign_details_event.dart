import 'package:equatable/equatable.dart';

sealed class CampaignDetailsEvent extends Equatable {
  const CampaignDetailsEvent();
}

final class LoadCampaignEvent extends CampaignDetailsEvent {
  final String id;

  const LoadCampaignEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
