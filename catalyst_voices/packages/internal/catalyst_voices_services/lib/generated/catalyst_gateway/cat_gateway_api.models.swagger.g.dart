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

Cip36Info _$Cip36InfoFromJson(Map<String, dynamic> json) => Cip36Info(
      stakePubKey: json['stake_pub_key'] as String,
      nonce: (json['nonce'] as num).toInt(),
      slotNo: (json['slot_no'] as num).toInt(),
      txn: (json['txn'] as num).toInt(),
      voteKey: json['vote_key'] as String,
      paymentAddress: json['payment_address'] as String,
      isPayable: json['is_payable'] as bool,
      cip36: json['cip36'] as bool,
    );

Map<String, dynamic> _$Cip36InfoToJson(Cip36Info instance) => <String, dynamic>{
      'stake_pub_key': instance.stakePubKey,
      'nonce': instance.nonce,
      'slot_no': instance.slotNo,
      'txn': instance.txn,
      'vote_key': instance.voteKey,
      'payment_address': instance.paymentAddress,
      'is_payable': instance.isPayable,
      'cip36': instance.cip36,
    };

Cip36Reporting _$Cip36ReportingFromJson(Map<String, dynamic> json) =>
    Cip36Reporting(
      cip36: (json['cip36'] as List<dynamic>?)
              ?.map((e) => Cip36Info.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      invalids: (json['invalids'] as List<dynamic>?)
              ?.map((e) => InvalidRegistrationsReport.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$Cip36ReportingToJson(Cip36Reporting instance) =>
    <String, dynamic>{
      'cip36': instance.cip36.map((e) => e.toJson()).toList(),
      'invalids': instance.invalids.map((e) => e.toJson()).toList(),
    };

Cip36ReportingList _$Cip36ReportingListFromJson(Map<String, dynamic> json) =>
    Cip36ReportingList(
      cip36: (json['cip36'] as List<dynamic>?)
              ?.map((e) => Cip36Reporting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$Cip36ReportingListToJson(Cip36ReportingList instance) =>
    <String, dynamic>{
      'cip36': instance.cip36.map((e) => e.toJson()).toList(),
    };

ConfigBadRequest _$ConfigBadRequestFromJson(Map<String, dynamic> json) =>
    ConfigBadRequest(
      error: json['error'] as String,
      schemaValidationErrors:
          (json['schema_validation_errors'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              [],
    );

Map<String, dynamic> _$ConfigBadRequestToJson(ConfigBadRequest instance) =>
    <String, dynamic>{
      'error': instance.error,
      'schema_validation_errors': instance.schemaValidationErrors,
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

Delegation _$DelegationFromJson(Map<String, dynamic> json) => Delegation(
      votingKey: json['voting_key'] as String,
      power: (json['power'] as num).toInt(),
    );

Map<String, dynamic> _$DelegationToJson(Delegation instance) =>
    <String, dynamic>{
      'voting_key': instance.votingKey,
      'power': instance.power,
    };

Delegations _$DelegationsFromJson(Map<String, dynamic> json) => Delegations(
      delegations: (json['delegations'] as List<dynamic>?)
              ?.map((e) => Delegation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DelegationsToJson(Delegations instance) =>
    <String, dynamic>{
      'delegations': instance.delegations.map((e) => e.toJson()).toList(),
    };

DirectVoter _$DirectVoterFromJson(Map<String, dynamic> json) => DirectVoter(
      votingKey: json['voting_key'] as String,
    );

Map<String, dynamic> _$DirectVoterToJson(DirectVoter instance) =>
    <String, dynamic>{
      'voting_key': instance.votingKey,
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

FrontendConfig _$FrontendConfigFromJson(Map<String, dynamic> json) =>
    FrontendConfig(
      sentry: json['sentry'] == null
          ? null
          : Sentry.fromJson(json['sentry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FrontendConfigToJson(FrontendConfig instance) =>
    <String, dynamic>{
      'sentry': instance.sentry?.toJson(),
    };

FullStakeInfo _$FullStakeInfoFromJson(Map<String, dynamic> json) =>
    FullStakeInfo(
      volatile: StakeInfo.fromJson(json['volatile'] as Map<String, dynamic>),
      persistent:
          StakeInfo.fromJson(json['persistent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FullStakeInfoToJson(FullStakeInfo instance) =>
    <String, dynamic>{
      'volatile': instance.volatile.toJson(),
      'persistent': instance.persistent.toJson(),
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

InvalidRegistrationsReport _$InvalidRegistrationsReportFromJson(
        Map<String, dynamic> json) =>
    InvalidRegistrationsReport(
      errorReport: (json['error_report'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      stakeAddress: json['stake_address'] as String,
      voteKey: json['vote_key'] as String,
      paymentAddress: json['payment_address'] as String,
      isPayable: json['is_payable'] as bool,
      cip36: json['cip36'] as bool,
    );

Map<String, dynamic> _$InvalidRegistrationsReportToJson(
        InvalidRegistrationsReport instance) =>
    <String, dynamic>{
      'error_report': instance.errorReport,
      'stake_address': instance.stakeAddress,
      'vote_key': instance.voteKey,
      'payment_address': instance.paymentAddress,
      'is_payable': instance.isPayable,
      'cip36': instance.cip36,
    };

RbacRegistration _$RbacRegistrationFromJson(Map<String, dynamic> json) =>
    RbacRegistration(
      txHash: json['tx_hash'] as String,
    );

Map<String, dynamic> _$RbacRegistrationToJson(RbacRegistration instance) =>
    <String, dynamic>{
      'tx_hash': instance.txHash,
    };

RbacRegistrationsResponse _$RbacRegistrationsResponseFromJson(
        Map<String, dynamic> json) =>
    RbacRegistrationsResponse(
      registrations: (json['registrations'] as List<dynamic>?)
              ?.map((e) => RbacRegistration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RbacRegistrationsResponseToJson(
        RbacRegistrationsResponse instance) =>
    <String, dynamic>{
      'registrations': instance.registrations.map((e) => e.toJson()).toList(),
    };

RbacRole0ChainRootResponse _$RbacRole0ChainRootResponseFromJson(
        Map<String, dynamic> json) =>
    RbacRole0ChainRootResponse(
      chainRoot: json['chain_root'] as String,
    );

Map<String, dynamic> _$RbacRole0ChainRootResponseToJson(
        RbacRole0ChainRootResponse instance) =>
    <String, dynamic>{
      'chain_root': instance.chainRoot,
    };

RegistrationInfo _$RegistrationInfoFromJson(Map<String, dynamic> json) =>
    RegistrationInfo(
      rewardsAddress: json['rewards_address'] as String,
      txHash: json['tx_hash'] as String,
      nonce: (json['nonce'] as num).toInt(),
      votingInfo:
          VotingInfo.fromJson(json['voting_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegistrationInfoToJson(RegistrationInfo instance) =>
    <String, dynamic>{
      'rewards_address': instance.rewardsAddress,
      'tx_hash': instance.txHash,
      'nonce': instance.nonce,
      'voting_info': instance.votingInfo.toJson(),
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

Response$ _$Response$FromJson(Map<String, dynamic> json) => Response$(
      chainRoot: json['chain_root'] as String,
    );

Map<String, dynamic> _$Response$ToJson(Response$ instance) => <String, dynamic>{
      'chain_root': instance.chainRoot,
    };

Sentry _$SentryFromJson(Map<String, dynamic> json) => Sentry(
      dsn: json['dsn'] as String,
      release: json['release'] as String?,
      environment: json['environment'] as String?,
    );

Map<String, dynamic> _$SentryToJson(Sentry instance) => <String, dynamic>{
      'dsn': instance.dsn,
      'release': instance.release,
      'environment': instance.environment,
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

Slot _$SlotFromJson(Map<String, dynamic> json) => Slot(
      slotNumber: (json['slot_number'] as num).toInt(),
      blockHash: json['block_hash'] as String,
      blockTime: DateTime.parse(json['block_time'] as String),
    );

Map<String, dynamic> _$SlotToJson(Slot instance) => <String, dynamic>{
      'slot_number': instance.slotNumber,
      'block_hash': instance.blockHash,
      'block_time': instance.blockTime.toIso8601String(),
    };

SlotInfo _$SlotInfoFromJson(Map<String, dynamic> json) => SlotInfo(
      previous: json['previous'] == null
          ? null
          : Slot.fromJson(json['previous'] as Map<String, dynamic>),
      current: json['current'] == null
          ? null
          : Slot.fromJson(json['current'] as Map<String, dynamic>),
      next: json['next'] == null
          ? null
          : Slot.fromJson(json['next'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SlotInfoToJson(SlotInfo instance) => <String, dynamic>{
      'previous': instance.previous?.toJson(),
      'current': instance.current?.toJson(),
      'next': instance.next?.toJson(),
    };

StakeInfo _$StakeInfoFromJson(Map<String, dynamic> json) => StakeInfo(
      adaAmount: (json['ada_amount'] as num).toInt(),
      slotNumber: (json['slot_number'] as num).toInt(),
      nativeTokens: (json['native_tokens'] as List<dynamic>?)
              ?.map((e) =>
                  StakedNativeTokenInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$StakeInfoToJson(StakeInfo instance) => <String, dynamic>{
      'ada_amount': instance.adaAmount,
      'slot_number': instance.slotNumber,
      'native_tokens': instance.nativeTokens.map((e) => e.toJson()).toList(),
    };

StakedNativeTokenInfo _$StakedNativeTokenInfoFromJson(
        Map<String, dynamic> json) =>
    StakedNativeTokenInfo(
      policyHash: json['policy_hash'] as String,
      assetName: json['asset_name'] as String,
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$StakedNativeTokenInfoToJson(
        StakedNativeTokenInfo instance) =>
    <String, dynamic>{
      'policy_hash': instance.policyHash,
      'asset_name': instance.assetName,
      'amount': instance.amount,
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

SyncState _$SyncStateFromJson(Map<String, dynamic> json) => SyncState(
      slotNumber: (json['slot_number'] as num).toInt(),
      blockHash: json['block_hash'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$SyncStateToJson(SyncState instance) => <String, dynamic>{
      'slot_number': instance.slotNumber,
      'block_hash': instance.blockHash,
      'last_updated': instance.lastUpdated.toIso8601String(),
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

VotingInfo _$VotingInfoFromJson(Map<String, dynamic> json) => VotingInfo();

Map<String, dynamic> _$VotingInfoToJson(VotingInfo instance) =>
    <String, dynamic>{};

VotingInfoDelegations _$VotingInfoDelegationsFromJson(
        Map<String, dynamic> json) =>
    VotingInfoDelegations(
      type: votingInfoDelegationsTypeFromJson(json['type']),
      delegations: (json['delegations'] as List<dynamic>?)
              ?.map((e) => Delegation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$VotingInfoDelegationsToJson(
        VotingInfoDelegations instance) =>
    <String, dynamic>{
      'type': votingInfoDelegationsTypeToJson(instance.type),
      'delegations': instance.delegations.map((e) => e.toJson()).toList(),
    };

VotingInfoDirectVoter _$VotingInfoDirectVoterFromJson(
        Map<String, dynamic> json) =>
    VotingInfoDirectVoter(
      type: votingInfoDirectVoterTypeFromJson(json['type']),
      votingKey: json['voting_key'] as String,
    );

Map<String, dynamic> _$VotingInfoDirectVoterToJson(
        VotingInfoDirectVoter instance) =>
    <String, dynamic>{
      'type': votingInfoDirectVoterTypeToJson(instance.type),
      'voting_key': instance.votingKey,
    };
