import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignSyncRequest extends DocumentsSyncRequest {
  final Campaign campaign;

  const CampaignSyncRequest(
    this.campaign, {
    super.periodic,
  });

  const CampaignSyncRequest.periodic(this.campaign) : super(periodic: const Duration(minutes: 15));

  @override
  List<Object?> get props => [campaign, periodic];

  @override
  CampaignSyncRequest copyWith({
    Campaign? campaign,
    Optional<Duration>? periodic,
  }) {
    return CampaignSyncRequest(
      campaign ?? this.campaign,
      periodic: periodic.dataOr(this.periodic),
    );
  }

  @override
  List<DocumentIndexFilters> steps() {
    return [
      DocumentIndexFilters.forCampaign(campaign: campaign, type: DocumentType.proposalTemplate),
      DocumentIndexFilters.forCampaign(campaign: campaign, type: DocumentType.commentTemplate),
      DocumentIndexFilters.forCampaign(campaign: campaign),
    ];
  }

  @override
  String toString() {
    return periodic != null
        ? 'CampaignSyncRequest(f${campaign.fundNumber} periodic: $periodic)'
        : 'CampaignSyncRequest(f${campaign.fundNumber})';
  }
}

sealed class DocumentsSyncRequest extends Equatable {
  final Duration? periodic;

  const DocumentsSyncRequest({
    this.periodic,
  });

  const factory DocumentsSyncRequest.campaign(
    Campaign campaign, {
    Duration? periodic,
  }) = CampaignSyncRequest;

  const factory DocumentsSyncRequest.target(SignedDocumentRef id) = TargetSyncRequest;

  bool get isPeriodic => periodic != null;

  DocumentsSyncRequest copyWith({
    Optional<Duration>? periodic,
  });

  List<DocumentIndexFilters> steps();
}

final class TargetSyncRequest extends DocumentsSyncRequest {
  final SignedDocumentRef id;

  const TargetSyncRequest(
    this.id, {
    super.periodic,
  });

  @override
  List<Object?> get props => [id, periodic];

  @override
  TargetSyncRequest copyWith({
    SignedDocumentRef? id,
    Optional<Duration>? periodic,
  }) {
    return TargetSyncRequest(
      id ?? this.id,
      periodic: periodic.dataOr(this.periodic),
    );
  }

  @override
  List<DocumentIndexFilters> steps() {
    return [
      DocumentIndexFilters.forTarget(id),
    ];
  }

  @override
  String toString() {
    final buffer = StringBuffer('TargetSyncRequest(id:${id.id}');

    if (id.isExact) buffer.write(', ver:${id.ver}');
    if (periodic != null) buffer.write(', periodic: $periodic');

    buffer.write(')');

    return buffer.toString();
  }
}
