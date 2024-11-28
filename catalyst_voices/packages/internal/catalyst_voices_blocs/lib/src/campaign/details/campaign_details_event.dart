import 'package:equatable/equatable.dart';

sealed class CampaignDetailsEvent extends Equatable {
  const CampaignDetailsEvent();
}

final class LoadCampaign extends CampaignDetailsEvent {
  final String id;

  const LoadCampaign({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
