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

final class ParametersSyncRequest extends DocumentsSyncRequest {
  final DocumentParameters parameters;
  final DocumentType? type;

  const ParametersSyncRequest(
    this.parameters, {
    this.type,
    super.periodic,
  });

  const ParametersSyncRequest.commentTemplate(this.parameters)
    : type = DocumentType.commentTemplate;

  @override
  List<Object?> get props => [parameters, type, periodic];

  @override
  ParametersSyncRequest copyWith({
    DocumentParameters? parameters,
    Optional<DocumentType>? type,
    Optional<Duration>? periodic,
  }) {
    return ParametersSyncRequest(
      parameters ?? this.parameters,
      type: type.dataOr(this.type),
      periodic: periodic.dataOr(this.periodic),
    );
  }

  @override
  List<DocumentIndexFilters> steps() {
    final type = this.type;
    return [
      DocumentIndexFilters(
        parameters: parameters.set.map((e) => e.id).toList(),
        type: type != null ? [type] : null,
      ),
    ];
  }

  @override
  String toString() {
    final buffer = StringBuffer('ParametersSyncRequest($parameters');

    if (periodic != null) buffer.write(', periodic: $periodic');

    buffer.write(')');

    return buffer.toString();
  }
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
