// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_gateway_api.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountVote _$AccountVoteFromJson(Map<String, dynamic> json) => AccountVote(
      votePlanId: json['vote_plan_id'] as String,
      votes: (json['votes'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
    );

Map<String, dynamic> _$AccountVoteToJson(AccountVote instance) =>
    <String, dynamic>{
      'vote_plan_id': instance.votePlanId,
      'votes': instance.votes,
    };

BlockDate _$BlockDateFromJson(Map<String, dynamic> json) => BlockDate(
      epoch: (json['epoch'] as num).toInt(),
      slotId: (json['slot_id'] as num).toInt(),
    );

Map<String, dynamic> _$BlockDateToJson(BlockDate instance) => <String, dynamic>{
      'epoch': instance.epoch,
      'slot_id': instance.slotId,
    };

ContentErrorDetail _$ContentErrorDetailFromJson(Map<String, dynamic> json) =>
    ContentErrorDetail(
      loc: (json['loc'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      msg: json['msg'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ContentErrorDetailToJson(ContentErrorDetail instance) =>
    <String, dynamic>{
      'loc': instance.loc,
      'msg': instance.msg,
      'type': instance.type,
    };

DelegatePublicKey _$DelegatePublicKeyFromJson(Map<String, dynamic> json) =>
    DelegatePublicKey(
      address: json['address'] as String,
    );

Map<String, dynamic> _$DelegatePublicKeyToJson(DelegatePublicKey instance) =>
    <String, dynamic>{
      'address': instance.address,
    };

Forbidden _$ForbiddenFromJson(Map<String, dynamic> json) => Forbidden(
      id: json['id'] as String,
      msg: json['msg'] as String,
      required: (json['required'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ForbiddenToJson(Forbidden instance) => <String, dynamic>{
      'id': instance.id,
      'msg': instance.msg,
      'required': instance.required,
    };

FragmentStatus _$FragmentStatusFromJson(Map<String, dynamic> json) =>
    FragmentStatus();

Map<String, dynamic> _$FragmentStatusToJson(FragmentStatus instance) =>
    <String, dynamic>{};

FragmentsBatch _$FragmentsBatchFromJson(Map<String, dynamic> json) =>
    FragmentsBatch(
      failFast: json['fail_fast'] as bool,
      fragments: (json['fragments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$FragmentsBatchToJson(FragmentsBatch instance) =>
    <String, dynamic>{
      'fail_fast': instance.failFast,
      'fragments': instance.fragments,
    };

FragmentsProcessingSummary _$FragmentsProcessingSummaryFromJson(
        Map<String, dynamic> json) =>
    FragmentsProcessingSummary(
      accepted: (json['accepted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rejected: (json['rejected'] as List<dynamic>?)
              ?.map((e) => RejectedFragment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$FragmentsProcessingSummaryToJson(
        FragmentsProcessingSummary instance) =>
    <String, dynamic>{
      'accepted': instance.accepted,
      'rejected': instance.rejected.map((e) => e.toJson()).toList(),
    };

Hash _$HashFromJson(Map<String, dynamic> json) => Hash(
      hash: json['hash'] as String,
    );

Map<String, dynamic> _$HashToJson(Hash instance) => <String, dynamic>{
      'hash': instance.hash,
    };

InternalServerError _$InternalServerErrorFromJson(Map<String, dynamic> json) =>
    InternalServerError(
      id: json['id'] as String,
      msg: json['msg'] as String,
      issue: json['issue'] as String?,
    );

Map<String, dynamic> _$InternalServerErrorToJson(
        InternalServerError instance) =>
    <String, dynamic>{
      'id': instance.id,
      'msg': instance.msg,
      'issue': instance.issue,
    };

RejectedFragment _$RejectedFragmentFromJson(Map<String, dynamic> json) =>
    RejectedFragment(
      id: json['id'] as String,
      poolNumber: (json['pool_number'] as num).toInt(),
      reason: reasonRejectedFromJson(json['reason']),
    );

Map<String, dynamic> _$RejectedFragmentToJson(RejectedFragment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pool_number': instance.poolNumber,
      'reason': reasonRejectedToJson(instance.reason),
    };

ServiceUnavailable _$ServiceUnavailableFromJson(Map<String, dynamic> json) =>
    ServiceUnavailable(
      id: json['id'] as String,
      msg: json['msg'] as String,
    );

Map<String, dynamic> _$ServiceUnavailableToJson(ServiceUnavailable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'msg': instance.msg,
    };

StatusInABlock _$StatusInABlockFromJson(Map<String, dynamic> json) =>
    StatusInABlock(
      date: BlockDate.fromJson(json['date'] as Map<String, dynamic>),
      block: Hash.fromJson(json['block'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatusInABlockToJson(StatusInABlock instance) =>
    <String, dynamic>{
      'date': instance.date.toJson(),
      'block': instance.block.toJson(),
    };

StatusPending _$StatusPendingFromJson(Map<String, dynamic> json) =>
    StatusPending();

Map<String, dynamic> _$StatusPendingToJson(StatusPending instance) =>
    <String, dynamic>{};

StatusRejected _$StatusRejectedFromJson(Map<String, dynamic> json) =>
    StatusRejected(
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$StatusRejectedToJson(StatusRejected instance) =>
    <String, dynamic>{
      'reason': instance.reason,
    };

TooManyRequests _$TooManyRequestsFromJson(Map<String, dynamic> json) =>
    TooManyRequests(
      id: json['id'] as String,
      msg: json['msg'] as String,
    );

Map<String, dynamic> _$TooManyRequestsToJson(TooManyRequests instance) =>
    <String, dynamic>{
      'id': instance.id,
      'msg': instance.msg,
    };

Unauthorized _$UnauthorizedFromJson(Map<String, dynamic> json) => Unauthorized(
      id: json['id'] as String,
      msg: json['msg'] as String,
    );

Map<String, dynamic> _$UnauthorizedToJson(Unauthorized instance) =>
    <String, dynamic>{
      'id': instance.id,
      'msg': instance.msg,
    };

UnprocessableContent _$UnprocessableContentFromJson(
        Map<String, dynamic> json) =>
    UnprocessableContent(
      detail: (json['detail'] as List<dynamic>?)
              ?.map(
                  (e) => ContentErrorDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UnprocessableContentToJson(
        UnprocessableContent instance) =>
    <String, dynamic>{
      'detail': instance.detail.map((e) => e.toJson()).toList(),
    };

VotePlan _$VotePlanFromJson(Map<String, dynamic> json) => VotePlan(
      votingToken: json['voting_token'] as String,
    );

Map<String, dynamic> _$VotePlanToJson(VotePlan instance) => <String, dynamic>{
      'voting_token': instance.votingToken,
    };

VoterInfo _$VoterInfoFromJson(Map<String, dynamic> json) => VoterInfo(
      votingPower: (json['voting_power'] as num).toInt(),
      votingGroup: voterGroupIdFromJson(json['voting_group']),
      delegationsPower: (json['delegations_power'] as num).toInt(),
      delegationsCount: (json['delegations_count'] as num).toInt(),
      votingPowerSaturation:
          (json['voting_power_saturation'] as num).toDouble(),
      delegatorAddresses: (json['delegator_addresses'] as List<dynamic>?)
              ?.map(
                  (e) => DelegatePublicKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$VoterInfoToJson(VoterInfo instance) => <String, dynamic>{
      'voting_power': instance.votingPower,
      'voting_group': voterGroupIdToJson(instance.votingGroup),
      'delegations_power': instance.delegationsPower,
      'delegations_count': instance.delegationsCount,
      'voting_power_saturation': instance.votingPowerSaturation,
      'delegator_addresses':
          instance.delegatorAddresses?.map((e) => e.toJson()).toList(),
    };

VoterRegistration _$VoterRegistrationFromJson(Map<String, dynamic> json) =>
    VoterRegistration(
      voterInfo: VoterInfo.fromJson(json['voter_info'] as Map<String, dynamic>),
      asAt: DateTime.parse(json['as_at'] as String),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      $final: json['final'] as bool,
    );

Map<String, dynamic> _$VoterRegistrationToJson(VoterRegistration instance) =>
    <String, dynamic>{
      'voter_info': instance.voterInfo.toJson(),
      'as_at': instance.asAt.toIso8601String(),
      'last_updated': instance.lastUpdated.toIso8601String(),
      'final': instance.$final,
    };
