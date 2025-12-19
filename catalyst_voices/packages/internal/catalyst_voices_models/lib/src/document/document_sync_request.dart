import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignSyncRequest extends DocumentsSyncRequest {
  final Campaign campaign;

  const CampaignSyncRequest(this.campaign);

  @override
  List<Object?> get props => [campaign];

  @override
  DocumentIndexFilters toIndexFilters() => DocumentIndexFilters.forCampaign(campaign: campaign);

  @override
  String toString() => 'CampaignSyncRequest(f${campaign.fundNumber})';
}

sealed class DocumentsSyncRequest extends Equatable {
  const DocumentsSyncRequest();

  const factory DocumentsSyncRequest.campaign(Campaign campaign) = CampaignSyncRequest;

  const factory DocumentsSyncRequest.target(SignedDocumentRef id) = TargetSyncRequest;

  DocumentIndexFilters toIndexFilters();
}

final class TargetSyncRequest extends DocumentsSyncRequest {
  final SignedDocumentRef id;

  const TargetSyncRequest(this.id);

  @override
  List<Object?> get props => [id];

  @override
  DocumentIndexFilters toIndexFilters() => DocumentIndexFilters.forTarget(id);

  @override
  String toString() => 'TargetSyncRequest(id:${id.id}, ver:${id.ver})';
}
