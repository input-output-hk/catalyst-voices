// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'cat_gateway_api.enums.swagger.dart' as enums;

part 'cat_gateway_api.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class AccountVote {
  const AccountVote({
    required this.votePlanId,
    required this.votes,
  });

  factory AccountVote.fromJson(Map<String, dynamic> json) =>
      _$AccountVoteFromJson(json);

  static const toJsonFactory = _$AccountVoteToJson;
  Map<String, dynamic> toJson() => _$AccountVoteToJson(this);

  @JsonKey(name: 'vote_plan_id')
  final String votePlanId;
  @JsonKey(name: 'votes', defaultValue: <int>[])
  final List<int> votes;
  static const fromJsonFactory = _$AccountVoteFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AccountVote &&
            (identical(other.votePlanId, votePlanId) ||
                const DeepCollectionEquality()
                    .equals(other.votePlanId, votePlanId)) &&
            (identical(other.votes, votes) ||
                const DeepCollectionEquality().equals(other.votes, votes)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(votePlanId) ^
      const DeepCollectionEquality().hash(votes) ^
      runtimeType.hashCode;
}

extension $AccountVoteExtension on AccountVote {
  AccountVote copyWith({String? votePlanId, List<int>? votes}) {
    return AccountVote(
        votePlanId: votePlanId ?? this.votePlanId, votes: votes ?? this.votes);
  }

  AccountVote copyWithWrapped(
      {Wrapped<String>? votePlanId, Wrapped<List<int>>? votes}) {
    return AccountVote(
        votePlanId: (votePlanId != null ? votePlanId.value : this.votePlanId),
        votes: (votes != null ? votes.value : this.votes));
  }
}

@JsonSerializable(explicitToJson: true)
class BlockDate {
  const BlockDate({
    required this.epoch,
    required this.slotId,
  });

  factory BlockDate.fromJson(Map<String, dynamic> json) =>
      _$BlockDateFromJson(json);

  static const toJsonFactory = _$BlockDateToJson;
  Map<String, dynamic> toJson() => _$BlockDateToJson(this);

  @JsonKey(name: 'epoch')
  final int epoch;
  @JsonKey(name: 'slot_id')
  final int slotId;
  static const fromJsonFactory = _$BlockDateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BlockDate &&
            (identical(other.epoch, epoch) ||
                const DeepCollectionEquality().equals(other.epoch, epoch)) &&
            (identical(other.slotId, slotId) ||
                const DeepCollectionEquality().equals(other.slotId, slotId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(epoch) ^
      const DeepCollectionEquality().hash(slotId) ^
      runtimeType.hashCode;
}

extension $BlockDateExtension on BlockDate {
  BlockDate copyWith({int? epoch, int? slotId}) {
    return BlockDate(epoch: epoch ?? this.epoch, slotId: slotId ?? this.slotId);
  }

  BlockDate copyWithWrapped({Wrapped<int>? epoch, Wrapped<int>? slotId}) {
    return BlockDate(
        epoch: (epoch != null ? epoch.value : this.epoch),
        slotId: (slotId != null ? slotId.value : this.slotId));
  }
}

@JsonSerializable(explicitToJson: true)
class Cip36Info {
  const Cip36Info({
    required this.stakeAddress,
    required this.nonce,
    required this.slotNo,
    required this.txn,
    required this.voteKey,
    required this.paymentAddress,
    required this.isPayable,
    required this.cip36,
  });

  factory Cip36Info.fromJson(Map<String, dynamic> json) =>
      _$Cip36InfoFromJson(json);

  static const toJsonFactory = _$Cip36InfoToJson;
  Map<String, dynamic> toJson() => _$Cip36InfoToJson(this);

  @JsonKey(name: 'stake_address')
  final String stakeAddress;
  @JsonKey(name: 'nonce')
  final int nonce;
  @JsonKey(name: 'slot_no')
  final int slotNo;
  @JsonKey(name: 'txn')
  final int txn;
  @JsonKey(name: 'vote_key')
  final String voteKey;
  @JsonKey(name: 'payment_address')
  final String paymentAddress;
  @JsonKey(name: 'is_payable')
  final bool isPayable;
  @JsonKey(name: 'cip36')
  final bool cip36;
  static const fromJsonFactory = _$Cip36InfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Cip36Info &&
            (identical(other.stakeAddress, stakeAddress) ||
                const DeepCollectionEquality()
                    .equals(other.stakeAddress, stakeAddress)) &&
            (identical(other.nonce, nonce) ||
                const DeepCollectionEquality().equals(other.nonce, nonce)) &&
            (identical(other.slotNo, slotNo) ||
                const DeepCollectionEquality().equals(other.slotNo, slotNo)) &&
            (identical(other.txn, txn) ||
                const DeepCollectionEquality().equals(other.txn, txn)) &&
            (identical(other.voteKey, voteKey) ||
                const DeepCollectionEquality()
                    .equals(other.voteKey, voteKey)) &&
            (identical(other.paymentAddress, paymentAddress) ||
                const DeepCollectionEquality()
                    .equals(other.paymentAddress, paymentAddress)) &&
            (identical(other.isPayable, isPayable) ||
                const DeepCollectionEquality()
                    .equals(other.isPayable, isPayable)) &&
            (identical(other.cip36, cip36) ||
                const DeepCollectionEquality().equals(other.cip36, cip36)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(stakeAddress) ^
      const DeepCollectionEquality().hash(nonce) ^
      const DeepCollectionEquality().hash(slotNo) ^
      const DeepCollectionEquality().hash(txn) ^
      const DeepCollectionEquality().hash(voteKey) ^
      const DeepCollectionEquality().hash(paymentAddress) ^
      const DeepCollectionEquality().hash(isPayable) ^
      const DeepCollectionEquality().hash(cip36) ^
      runtimeType.hashCode;
}

extension $Cip36InfoExtension on Cip36Info {
  Cip36Info copyWith(
      {String? stakeAddress,
      int? nonce,
      int? slotNo,
      int? txn,
      String? voteKey,
      String? paymentAddress,
      bool? isPayable,
      bool? cip36}) {
    return Cip36Info(
        stakeAddress: stakeAddress ?? this.stakeAddress,
        nonce: nonce ?? this.nonce,
        slotNo: slotNo ?? this.slotNo,
        txn: txn ?? this.txn,
        voteKey: voteKey ?? this.voteKey,
        paymentAddress: paymentAddress ?? this.paymentAddress,
        isPayable: isPayable ?? this.isPayable,
        cip36: cip36 ?? this.cip36);
  }

  Cip36Info copyWithWrapped(
      {Wrapped<String>? stakeAddress,
      Wrapped<int>? nonce,
      Wrapped<int>? slotNo,
      Wrapped<int>? txn,
      Wrapped<String>? voteKey,
      Wrapped<String>? paymentAddress,
      Wrapped<bool>? isPayable,
      Wrapped<bool>? cip36}) {
    return Cip36Info(
        stakeAddress:
            (stakeAddress != null ? stakeAddress.value : this.stakeAddress),
        nonce: (nonce != null ? nonce.value : this.nonce),
        slotNo: (slotNo != null ? slotNo.value : this.slotNo),
        txn: (txn != null ? txn.value : this.txn),
        voteKey: (voteKey != null ? voteKey.value : this.voteKey),
        paymentAddress: (paymentAddress != null
            ? paymentAddress.value
            : this.paymentAddress),
        isPayable: (isPayable != null ? isPayable.value : this.isPayable),
        cip36: (cip36 != null ? cip36.value : this.cip36));
  }
}

@JsonSerializable(explicitToJson: true)
class Cip36Reporting {
  const Cip36Reporting({
    required this.cip36,
    required this.invalids,
  });

  factory Cip36Reporting.fromJson(Map<String, dynamic> json) =>
      _$Cip36ReportingFromJson(json);

  static const toJsonFactory = _$Cip36ReportingToJson;
  Map<String, dynamic> toJson() => _$Cip36ReportingToJson(this);

  @JsonKey(name: 'cip36', defaultValue: <Cip36Info>[])
  final List<Cip36Info> cip36;
  @JsonKey(name: 'invalids', defaultValue: <InvalidRegistrationsReport>[])
  final List<InvalidRegistrationsReport> invalids;
  static const fromJsonFactory = _$Cip36ReportingFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Cip36Reporting &&
            (identical(other.cip36, cip36) ||
                const DeepCollectionEquality().equals(other.cip36, cip36)) &&
            (identical(other.invalids, invalids) ||
                const DeepCollectionEquality()
                    .equals(other.invalids, invalids)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(cip36) ^
      const DeepCollectionEquality().hash(invalids) ^
      runtimeType.hashCode;
}

extension $Cip36ReportingExtension on Cip36Reporting {
  Cip36Reporting copyWith(
      {List<Cip36Info>? cip36, List<InvalidRegistrationsReport>? invalids}) {
    return Cip36Reporting(
        cip36: cip36 ?? this.cip36, invalids: invalids ?? this.invalids);
  }

  Cip36Reporting copyWithWrapped(
      {Wrapped<List<Cip36Info>>? cip36,
      Wrapped<List<InvalidRegistrationsReport>>? invalids}) {
    return Cip36Reporting(
        cip36: (cip36 != null ? cip36.value : this.cip36),
        invalids: (invalids != null ? invalids.value : this.invalids));
  }
}

@JsonSerializable(explicitToJson: true)
class Cip36ReportingList {
  const Cip36ReportingList({
    required this.cip36,
  });

  factory Cip36ReportingList.fromJson(Map<String, dynamic> json) =>
      _$Cip36ReportingListFromJson(json);

  static const toJsonFactory = _$Cip36ReportingListToJson;
  Map<String, dynamic> toJson() => _$Cip36ReportingListToJson(this);

  @JsonKey(name: 'cip36', defaultValue: <Cip36Reporting>[])
  final List<Cip36Reporting> cip36;
  static const fromJsonFactory = _$Cip36ReportingListFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Cip36ReportingList &&
            (identical(other.cip36, cip36) ||
                const DeepCollectionEquality().equals(other.cip36, cip36)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(cip36) ^ runtimeType.hashCode;
}

extension $Cip36ReportingListExtension on Cip36ReportingList {
  Cip36ReportingList copyWith({List<Cip36Reporting>? cip36}) {
    return Cip36ReportingList(cip36: cip36 ?? this.cip36);
  }

  Cip36ReportingList copyWithWrapped({Wrapped<List<Cip36Reporting>>? cip36}) {
    return Cip36ReportingList(
        cip36: (cip36 != null ? cip36.value : this.cip36));
  }
}

@JsonSerializable(explicitToJson: true)
class DelegatePublicKey {
  const DelegatePublicKey({
    required this.address,
  });

  factory DelegatePublicKey.fromJson(Map<String, dynamic> json) =>
      _$DelegatePublicKeyFromJson(json);

  static const toJsonFactory = _$DelegatePublicKeyToJson;
  Map<String, dynamic> toJson() => _$DelegatePublicKeyToJson(this);

  @JsonKey(name: 'address')
  final String address;
  static const fromJsonFactory = _$DelegatePublicKeyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DelegatePublicKey &&
            (identical(other.address, address) ||
                const DeepCollectionEquality().equals(other.address, address)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(address) ^ runtimeType.hashCode;
}

extension $DelegatePublicKeyExtension on DelegatePublicKey {
  DelegatePublicKey copyWith({String? address}) {
    return DelegatePublicKey(address: address ?? this.address);
  }

  DelegatePublicKey copyWithWrapped({Wrapped<String>? address}) {
    return DelegatePublicKey(
        address: (address != null ? address.value : this.address));
  }
}

@JsonSerializable(explicitToJson: true)
class Delegation {
  const Delegation({
    required this.votingKey,
    required this.power,
  });

  factory Delegation.fromJson(Map<String, dynamic> json) =>
      _$DelegationFromJson(json);

  static const toJsonFactory = _$DelegationToJson;
  Map<String, dynamic> toJson() => _$DelegationToJson(this);

  @JsonKey(name: 'voting_key')
  final String votingKey;
  @JsonKey(name: 'power')
  final int power;
  static const fromJsonFactory = _$DelegationFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Delegation &&
            (identical(other.votingKey, votingKey) ||
                const DeepCollectionEquality()
                    .equals(other.votingKey, votingKey)) &&
            (identical(other.power, power) ||
                const DeepCollectionEquality().equals(other.power, power)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(votingKey) ^
      const DeepCollectionEquality().hash(power) ^
      runtimeType.hashCode;
}

extension $DelegationExtension on Delegation {
  Delegation copyWith({String? votingKey, int? power}) {
    return Delegation(
        votingKey: votingKey ?? this.votingKey, power: power ?? this.power);
  }

  Delegation copyWithWrapped(
      {Wrapped<String>? votingKey, Wrapped<int>? power}) {
    return Delegation(
        votingKey: (votingKey != null ? votingKey.value : this.votingKey),
        power: (power != null ? power.value : this.power));
  }
}

@JsonSerializable(explicitToJson: true)
class Delegations {
  const Delegations({
    required this.delegations,
  });

  factory Delegations.fromJson(Map<String, dynamic> json) =>
      _$DelegationsFromJson(json);

  static const toJsonFactory = _$DelegationsToJson;
  Map<String, dynamic> toJson() => _$DelegationsToJson(this);

  @JsonKey(name: 'delegations', defaultValue: <Delegation>[])
  final List<Delegation> delegations;
  static const fromJsonFactory = _$DelegationsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Delegations &&
            (identical(other.delegations, delegations) ||
                const DeepCollectionEquality()
                    .equals(other.delegations, delegations)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(delegations) ^ runtimeType.hashCode;
}

extension $DelegationsExtension on Delegations {
  Delegations copyWith({List<Delegation>? delegations}) {
    return Delegations(delegations: delegations ?? this.delegations);
  }

  Delegations copyWithWrapped({Wrapped<List<Delegation>>? delegations}) {
    return Delegations(
        delegations:
            (delegations != null ? delegations.value : this.delegations));
  }
}

@JsonSerializable(explicitToJson: true)
class DirectVoter {
  const DirectVoter({
    required this.votingKey,
  });

  factory DirectVoter.fromJson(Map<String, dynamic> json) =>
      _$DirectVoterFromJson(json);

  static const toJsonFactory = _$DirectVoterToJson;
  Map<String, dynamic> toJson() => _$DirectVoterToJson(this);

  @JsonKey(name: 'voting_key')
  final String votingKey;
  static const fromJsonFactory = _$DirectVoterFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DirectVoter &&
            (identical(other.votingKey, votingKey) ||
                const DeepCollectionEquality()
                    .equals(other.votingKey, votingKey)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(votingKey) ^ runtimeType.hashCode;
}

extension $DirectVoterExtension on DirectVoter {
  DirectVoter copyWith({String? votingKey}) {
    return DirectVoter(votingKey: votingKey ?? this.votingKey);
  }

  DirectVoter copyWithWrapped({Wrapped<String>? votingKey}) {
    return DirectVoter(
        votingKey: (votingKey != null ? votingKey.value : this.votingKey));
  }
}

@JsonSerializable(explicitToJson: true)
class FragmentStatus {
  const FragmentStatus();

  factory FragmentStatus.fromJson(Map<String, dynamic> json) =>
      _$FragmentStatusFromJson(json);

  static const toJsonFactory = _$FragmentStatusToJson;
  Map<String, dynamic> toJson() => _$FragmentStatusToJson(this);

  static const fromJsonFactory = _$FragmentStatusFromJson;

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode => runtimeType.hashCode;
}

@JsonSerializable(explicitToJson: true)
class FragmentsBatch {
  const FragmentsBatch({
    required this.failFast,
    required this.fragments,
  });

  factory FragmentsBatch.fromJson(Map<String, dynamic> json) =>
      _$FragmentsBatchFromJson(json);

  static const toJsonFactory = _$FragmentsBatchToJson;
  Map<String, dynamic> toJson() => _$FragmentsBatchToJson(this);

  @JsonKey(name: 'fail_fast')
  final bool failFast;
  @JsonKey(name: 'fragments', defaultValue: <String>[])
  final List<String> fragments;
  static const fromJsonFactory = _$FragmentsBatchFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FragmentsBatch &&
            (identical(other.failFast, failFast) ||
                const DeepCollectionEquality()
                    .equals(other.failFast, failFast)) &&
            (identical(other.fragments, fragments) ||
                const DeepCollectionEquality()
                    .equals(other.fragments, fragments)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(failFast) ^
      const DeepCollectionEquality().hash(fragments) ^
      runtimeType.hashCode;
}

extension $FragmentsBatchExtension on FragmentsBatch {
  FragmentsBatch copyWith({bool? failFast, List<String>? fragments}) {
    return FragmentsBatch(
        failFast: failFast ?? this.failFast,
        fragments: fragments ?? this.fragments);
  }

  FragmentsBatch copyWithWrapped(
      {Wrapped<bool>? failFast, Wrapped<List<String>>? fragments}) {
    return FragmentsBatch(
        failFast: (failFast != null ? failFast.value : this.failFast),
        fragments: (fragments != null ? fragments.value : this.fragments));
  }
}

@JsonSerializable(explicitToJson: true)
class FragmentsProcessingSummary {
  const FragmentsProcessingSummary({
    required this.accepted,
    required this.rejected,
  });

  factory FragmentsProcessingSummary.fromJson(Map<String, dynamic> json) =>
      _$FragmentsProcessingSummaryFromJson(json);

  static const toJsonFactory = _$FragmentsProcessingSummaryToJson;
  Map<String, dynamic> toJson() => _$FragmentsProcessingSummaryToJson(this);

  @JsonKey(name: 'accepted', defaultValue: <String>[])
  final List<String> accepted;
  @JsonKey(name: 'rejected', defaultValue: <RejectedFragment>[])
  final List<RejectedFragment> rejected;
  static const fromJsonFactory = _$FragmentsProcessingSummaryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FragmentsProcessingSummary &&
            (identical(other.accepted, accepted) ||
                const DeepCollectionEquality()
                    .equals(other.accepted, accepted)) &&
            (identical(other.rejected, rejected) ||
                const DeepCollectionEquality()
                    .equals(other.rejected, rejected)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accepted) ^
      const DeepCollectionEquality().hash(rejected) ^
      runtimeType.hashCode;
}

extension $FragmentsProcessingSummaryExtension on FragmentsProcessingSummary {
  FragmentsProcessingSummary copyWith(
      {List<String>? accepted, List<RejectedFragment>? rejected}) {
    return FragmentsProcessingSummary(
        accepted: accepted ?? this.accepted,
        rejected: rejected ?? this.rejected);
  }

  FragmentsProcessingSummary copyWithWrapped(
      {Wrapped<List<String>>? accepted,
      Wrapped<List<RejectedFragment>>? rejected}) {
    return FragmentsProcessingSummary(
        accepted: (accepted != null ? accepted.value : this.accepted),
        rejected: (rejected != null ? rejected.value : this.rejected));
  }
}

@JsonSerializable(explicitToJson: true)
class FullStakeInfo {
  const FullStakeInfo({
    required this.volatile,
    required this.persistent,
  });

  factory FullStakeInfo.fromJson(Map<String, dynamic> json) =>
      _$FullStakeInfoFromJson(json);

  static const toJsonFactory = _$FullStakeInfoToJson;
  Map<String, dynamic> toJson() => _$FullStakeInfoToJson(this);

  @JsonKey(name: 'volatile')
  final StakeInfo volatile;
  @JsonKey(name: 'persistent')
  final StakeInfo persistent;
  static const fromJsonFactory = _$FullStakeInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FullStakeInfo &&
            (identical(other.volatile, volatile) ||
                const DeepCollectionEquality()
                    .equals(other.volatile, volatile)) &&
            (identical(other.persistent, persistent) ||
                const DeepCollectionEquality()
                    .equals(other.persistent, persistent)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(volatile) ^
      const DeepCollectionEquality().hash(persistent) ^
      runtimeType.hashCode;
}

extension $FullStakeInfoExtension on FullStakeInfo {
  FullStakeInfo copyWith({StakeInfo? volatile, StakeInfo? persistent}) {
    return FullStakeInfo(
        volatile: volatile ?? this.volatile,
        persistent: persistent ?? this.persistent);
  }

  FullStakeInfo copyWithWrapped(
      {Wrapped<StakeInfo>? volatile, Wrapped<StakeInfo>? persistent}) {
    return FullStakeInfo(
        volatile: (volatile != null ? volatile.value : this.volatile),
        persistent: (persistent != null ? persistent.value : this.persistent));
  }
}

@JsonSerializable(explicitToJson: true)
class Hash {
  const Hash({
    required this.hash,
  });

  factory Hash.fromJson(Map<String, dynamic> json) => _$HashFromJson(json);

  static const toJsonFactory = _$HashToJson;
  Map<String, dynamic> toJson() => _$HashToJson(this);

  @JsonKey(name: 'hash')
  final String hash;
  static const fromJsonFactory = _$HashFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Hash &&
            (identical(other.hash, hash) ||
                const DeepCollectionEquality().equals(other.hash, hash)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(hash) ^ runtimeType.hashCode;
}

extension $HashExtension on Hash {
  Hash copyWith({String? hash}) {
    return Hash(hash: hash ?? this.hash);
  }

  Hash copyWithWrapped({Wrapped<String>? hash}) {
    return Hash(hash: (hash != null ? hash.value : this.hash));
  }
}

@JsonSerializable(explicitToJson: true)
class InvalidRegistrationsReport {
  const InvalidRegistrationsReport({
    required this.errorReport,
    required this.stakeAddress,
    required this.voteKey,
    required this.paymentAddress,
    required this.isPayable,
    required this.cip36,
  });

  factory InvalidRegistrationsReport.fromJson(Map<String, dynamic> json) =>
      _$InvalidRegistrationsReportFromJson(json);

  static const toJsonFactory = _$InvalidRegistrationsReportToJson;
  Map<String, dynamic> toJson() => _$InvalidRegistrationsReportToJson(this);

  @JsonKey(name: 'error_report', defaultValue: <String>[])
  final List<String> errorReport;
  @JsonKey(name: 'stake_address')
  final String stakeAddress;
  @JsonKey(name: 'vote_key')
  final String voteKey;
  @JsonKey(name: 'payment_address')
  final String paymentAddress;
  @JsonKey(name: 'is_payable')
  final bool isPayable;
  @JsonKey(name: 'cip36')
  final bool cip36;
  static const fromJsonFactory = _$InvalidRegistrationsReportFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InvalidRegistrationsReport &&
            (identical(other.errorReport, errorReport) ||
                const DeepCollectionEquality()
                    .equals(other.errorReport, errorReport)) &&
            (identical(other.stakeAddress, stakeAddress) ||
                const DeepCollectionEquality()
                    .equals(other.stakeAddress, stakeAddress)) &&
            (identical(other.voteKey, voteKey) ||
                const DeepCollectionEquality()
                    .equals(other.voteKey, voteKey)) &&
            (identical(other.paymentAddress, paymentAddress) ||
                const DeepCollectionEquality()
                    .equals(other.paymentAddress, paymentAddress)) &&
            (identical(other.isPayable, isPayable) ||
                const DeepCollectionEquality()
                    .equals(other.isPayable, isPayable)) &&
            (identical(other.cip36, cip36) ||
                const DeepCollectionEquality().equals(other.cip36, cip36)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(errorReport) ^
      const DeepCollectionEquality().hash(stakeAddress) ^
      const DeepCollectionEquality().hash(voteKey) ^
      const DeepCollectionEquality().hash(paymentAddress) ^
      const DeepCollectionEquality().hash(isPayable) ^
      const DeepCollectionEquality().hash(cip36) ^
      runtimeType.hashCode;
}

extension $InvalidRegistrationsReportExtension on InvalidRegistrationsReport {
  InvalidRegistrationsReport copyWith(
      {List<String>? errorReport,
      String? stakeAddress,
      String? voteKey,
      String? paymentAddress,
      bool? isPayable,
      bool? cip36}) {
    return InvalidRegistrationsReport(
        errorReport: errorReport ?? this.errorReport,
        stakeAddress: stakeAddress ?? this.stakeAddress,
        voteKey: voteKey ?? this.voteKey,
        paymentAddress: paymentAddress ?? this.paymentAddress,
        isPayable: isPayable ?? this.isPayable,
        cip36: cip36 ?? this.cip36);
  }

  InvalidRegistrationsReport copyWithWrapped(
      {Wrapped<List<String>>? errorReport,
      Wrapped<String>? stakeAddress,
      Wrapped<String>? voteKey,
      Wrapped<String>? paymentAddress,
      Wrapped<bool>? isPayable,
      Wrapped<bool>? cip36}) {
    return InvalidRegistrationsReport(
        errorReport:
            (errorReport != null ? errorReport.value : this.errorReport),
        stakeAddress:
            (stakeAddress != null ? stakeAddress.value : this.stakeAddress),
        voteKey: (voteKey != null ? voteKey.value : this.voteKey),
        paymentAddress: (paymentAddress != null
            ? paymentAddress.value
            : this.paymentAddress),
        isPayable: (isPayable != null ? isPayable.value : this.isPayable),
        cip36: (cip36 != null ? cip36.value : this.cip36));
  }
}

@JsonSerializable(explicitToJson: true)
class RegistrationInfo {
  const RegistrationInfo({
    required this.rewardsAddress,
    required this.txHash,
    required this.nonce,
    required this.votingInfo,
  });

  factory RegistrationInfo.fromJson(Map<String, dynamic> json) =>
      _$RegistrationInfoFromJson(json);

  static const toJsonFactory = _$RegistrationInfoToJson;
  Map<String, dynamic> toJson() => _$RegistrationInfoToJson(this);

  @JsonKey(name: 'rewards_address')
  final String rewardsAddress;
  @JsonKey(name: 'tx_hash')
  final String txHash;
  @JsonKey(name: 'nonce')
  final int nonce;
  @JsonKey(name: 'voting_info')
  final VotingInfo votingInfo;
  static const fromJsonFactory = _$RegistrationInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegistrationInfo &&
            (identical(other.rewardsAddress, rewardsAddress) ||
                const DeepCollectionEquality()
                    .equals(other.rewardsAddress, rewardsAddress)) &&
            (identical(other.txHash, txHash) ||
                const DeepCollectionEquality().equals(other.txHash, txHash)) &&
            (identical(other.nonce, nonce) ||
                const DeepCollectionEquality().equals(other.nonce, nonce)) &&
            (identical(other.votingInfo, votingInfo) ||
                const DeepCollectionEquality()
                    .equals(other.votingInfo, votingInfo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(rewardsAddress) ^
      const DeepCollectionEquality().hash(txHash) ^
      const DeepCollectionEquality().hash(nonce) ^
      const DeepCollectionEquality().hash(votingInfo) ^
      runtimeType.hashCode;
}

extension $RegistrationInfoExtension on RegistrationInfo {
  RegistrationInfo copyWith(
      {String? rewardsAddress,
      String? txHash,
      int? nonce,
      VotingInfo? votingInfo}) {
    return RegistrationInfo(
        rewardsAddress: rewardsAddress ?? this.rewardsAddress,
        txHash: txHash ?? this.txHash,
        nonce: nonce ?? this.nonce,
        votingInfo: votingInfo ?? this.votingInfo);
  }

  RegistrationInfo copyWithWrapped(
      {Wrapped<String>? rewardsAddress,
      Wrapped<String>? txHash,
      Wrapped<int>? nonce,
      Wrapped<VotingInfo>? votingInfo}) {
    return RegistrationInfo(
        rewardsAddress: (rewardsAddress != null
            ? rewardsAddress.value
            : this.rewardsAddress),
        txHash: (txHash != null ? txHash.value : this.txHash),
        nonce: (nonce != null ? nonce.value : this.nonce),
        votingInfo: (votingInfo != null ? votingInfo.value : this.votingInfo));
  }
}

@JsonSerializable(explicitToJson: true)
class RejectedFragment {
  const RejectedFragment({
    required this.id,
    required this.poolNumber,
    required this.reason,
  });

  factory RejectedFragment.fromJson(Map<String, dynamic> json) =>
      _$RejectedFragmentFromJson(json);

  static const toJsonFactory = _$RejectedFragmentToJson;
  Map<String, dynamic> toJson() => _$RejectedFragmentToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'pool_number')
  final int poolNumber;
  @JsonKey(
    name: 'reason',
    toJson: reasonRejectedToJson,
    fromJson: reasonRejectedFromJson,
  )
  final enums.ReasonRejected reason;
  static const fromJsonFactory = _$RejectedFragmentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RejectedFragment &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.poolNumber, poolNumber) ||
                const DeepCollectionEquality()
                    .equals(other.poolNumber, poolNumber)) &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(poolNumber) ^
      const DeepCollectionEquality().hash(reason) ^
      runtimeType.hashCode;
}

extension $RejectedFragmentExtension on RejectedFragment {
  RejectedFragment copyWith(
      {String? id, int? poolNumber, enums.ReasonRejected? reason}) {
    return RejectedFragment(
        id: id ?? this.id,
        poolNumber: poolNumber ?? this.poolNumber,
        reason: reason ?? this.reason);
  }

  RejectedFragment copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<int>? poolNumber,
      Wrapped<enums.ReasonRejected>? reason}) {
    return RejectedFragment(
        id: (id != null ? id.value : this.id),
        poolNumber: (poolNumber != null ? poolNumber.value : this.poolNumber),
        reason: (reason != null ? reason.value : this.reason));
  }
}

@JsonSerializable(explicitToJson: true)
class ServerError {
  const ServerError({
    required this.id,
    required this.msg,
    this.issue,
  });

  factory ServerError.fromJson(Map<String, dynamic> json) =>
      _$ServerErrorFromJson(json);

  static const toJsonFactory = _$ServerErrorToJson;
  Map<String, dynamic> toJson() => _$ServerErrorToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'issue')
  final String? issue;
  static const fromJsonFactory = _$ServerErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ServerError &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.issue, issue) ||
                const DeepCollectionEquality().equals(other.issue, issue)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(issue) ^
      runtimeType.hashCode;
}

extension $ServerErrorExtension on ServerError {
  ServerError copyWith({String? id, String? msg, String? issue}) {
    return ServerError(
        id: id ?? this.id, msg: msg ?? this.msg, issue: issue ?? this.issue);
  }

  ServerError copyWithWrapped(
      {Wrapped<String>? id, Wrapped<String>? msg, Wrapped<String?>? issue}) {
    return ServerError(
        id: (id != null ? id.value : this.id),
        msg: (msg != null ? msg.value : this.msg),
        issue: (issue != null ? issue.value : this.issue));
  }
}

@JsonSerializable(explicitToJson: true)
class Slot {
  const Slot({
    required this.slotNumber,
    required this.blockHash,
    required this.blockTime,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

  static const toJsonFactory = _$SlotToJson;
  Map<String, dynamic> toJson() => _$SlotToJson(this);

  @JsonKey(name: 'slot_number')
  final int slotNumber;
  @JsonKey(name: 'block_hash')
  final String blockHash;
  @JsonKey(name: 'block_time')
  final DateTime blockTime;
  static const fromJsonFactory = _$SlotFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Slot &&
            (identical(other.slotNumber, slotNumber) ||
                const DeepCollectionEquality()
                    .equals(other.slotNumber, slotNumber)) &&
            (identical(other.blockHash, blockHash) ||
                const DeepCollectionEquality()
                    .equals(other.blockHash, blockHash)) &&
            (identical(other.blockTime, blockTime) ||
                const DeepCollectionEquality()
                    .equals(other.blockTime, blockTime)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(slotNumber) ^
      const DeepCollectionEquality().hash(blockHash) ^
      const DeepCollectionEquality().hash(blockTime) ^
      runtimeType.hashCode;
}

extension $SlotExtension on Slot {
  Slot copyWith({int? slotNumber, String? blockHash, DateTime? blockTime}) {
    return Slot(
        slotNumber: slotNumber ?? this.slotNumber,
        blockHash: blockHash ?? this.blockHash,
        blockTime: blockTime ?? this.blockTime);
  }

  Slot copyWithWrapped(
      {Wrapped<int>? slotNumber,
      Wrapped<String>? blockHash,
      Wrapped<DateTime>? blockTime}) {
    return Slot(
        slotNumber: (slotNumber != null ? slotNumber.value : this.slotNumber),
        blockHash: (blockHash != null ? blockHash.value : this.blockHash),
        blockTime: (blockTime != null ? blockTime.value : this.blockTime));
  }
}

@JsonSerializable(explicitToJson: true)
class SlotInfo {
  const SlotInfo({
    this.previous,
    this.current,
    this.next,
  });

  factory SlotInfo.fromJson(Map<String, dynamic> json) =>
      _$SlotInfoFromJson(json);

  static const toJsonFactory = _$SlotInfoToJson;
  Map<String, dynamic> toJson() => _$SlotInfoToJson(this);

  @JsonKey(name: 'previous')
  final Slot? previous;
  @JsonKey(name: 'current')
  final Slot? current;
  @JsonKey(name: 'next')
  final Slot? next;
  static const fromJsonFactory = _$SlotInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SlotInfo &&
            (identical(other.previous, previous) ||
                const DeepCollectionEquality()
                    .equals(other.previous, previous)) &&
            (identical(other.current, current) ||
                const DeepCollectionEquality()
                    .equals(other.current, current)) &&
            (identical(other.next, next) ||
                const DeepCollectionEquality().equals(other.next, next)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(previous) ^
      const DeepCollectionEquality().hash(current) ^
      const DeepCollectionEquality().hash(next) ^
      runtimeType.hashCode;
}

extension $SlotInfoExtension on SlotInfo {
  SlotInfo copyWith({Slot? previous, Slot? current, Slot? next}) {
    return SlotInfo(
        previous: previous ?? this.previous,
        current: current ?? this.current,
        next: next ?? this.next);
  }

  SlotInfo copyWithWrapped(
      {Wrapped<Slot?>? previous,
      Wrapped<Slot?>? current,
      Wrapped<Slot?>? next}) {
    return SlotInfo(
        previous: (previous != null ? previous.value : this.previous),
        current: (current != null ? current.value : this.current),
        next: (next != null ? next.value : this.next));
  }
}

@JsonSerializable(explicitToJson: true)
class StakeInfo {
  const StakeInfo({
    required this.adaAmount,
    required this.slotNumber,
    required this.nativeTokens,
  });

  factory StakeInfo.fromJson(Map<String, dynamic> json) =>
      _$StakeInfoFromJson(json);

  static const toJsonFactory = _$StakeInfoToJson;
  Map<String, dynamic> toJson() => _$StakeInfoToJson(this);

  @JsonKey(name: 'ada_amount')
  final int adaAmount;
  @JsonKey(name: 'slot_number')
  final int slotNumber;
  @JsonKey(name: 'native_tokens', defaultValue: <StakedNativeTokenInfo>[])
  final List<StakedNativeTokenInfo> nativeTokens;
  static const fromJsonFactory = _$StakeInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StakeInfo &&
            (identical(other.adaAmount, adaAmount) ||
                const DeepCollectionEquality()
                    .equals(other.adaAmount, adaAmount)) &&
            (identical(other.slotNumber, slotNumber) ||
                const DeepCollectionEquality()
                    .equals(other.slotNumber, slotNumber)) &&
            (identical(other.nativeTokens, nativeTokens) ||
                const DeepCollectionEquality()
                    .equals(other.nativeTokens, nativeTokens)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(adaAmount) ^
      const DeepCollectionEquality().hash(slotNumber) ^
      const DeepCollectionEquality().hash(nativeTokens) ^
      runtimeType.hashCode;
}

extension $StakeInfoExtension on StakeInfo {
  StakeInfo copyWith(
      {int? adaAmount,
      int? slotNumber,
      List<StakedNativeTokenInfo>? nativeTokens}) {
    return StakeInfo(
        adaAmount: adaAmount ?? this.adaAmount,
        slotNumber: slotNumber ?? this.slotNumber,
        nativeTokens: nativeTokens ?? this.nativeTokens);
  }

  StakeInfo copyWithWrapped(
      {Wrapped<int>? adaAmount,
      Wrapped<int>? slotNumber,
      Wrapped<List<StakedNativeTokenInfo>>? nativeTokens}) {
    return StakeInfo(
        adaAmount: (adaAmount != null ? adaAmount.value : this.adaAmount),
        slotNumber: (slotNumber != null ? slotNumber.value : this.slotNumber),
        nativeTokens:
            (nativeTokens != null ? nativeTokens.value : this.nativeTokens));
  }
}

@JsonSerializable(explicitToJson: true)
class StakedNativeTokenInfo {
  const StakedNativeTokenInfo({
    required this.policyHash,
    required this.policyName,
    required this.amount,
  });

  factory StakedNativeTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$StakedNativeTokenInfoFromJson(json);

  static const toJsonFactory = _$StakedNativeTokenInfoToJson;
  Map<String, dynamic> toJson() => _$StakedNativeTokenInfoToJson(this);

  @JsonKey(name: 'policy_hash')
  final String policyHash;
  @JsonKey(name: 'policy_name')
  final String policyName;
  @JsonKey(name: 'amount')
  final int amount;
  static const fromJsonFactory = _$StakedNativeTokenInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StakedNativeTokenInfo &&
            (identical(other.policyHash, policyHash) ||
                const DeepCollectionEquality()
                    .equals(other.policyHash, policyHash)) &&
            (identical(other.policyName, policyName) ||
                const DeepCollectionEquality()
                    .equals(other.policyName, policyName)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(policyHash) ^
      const DeepCollectionEquality().hash(policyName) ^
      const DeepCollectionEquality().hash(amount) ^
      runtimeType.hashCode;
}

extension $StakedNativeTokenInfoExtension on StakedNativeTokenInfo {
  StakedNativeTokenInfo copyWith(
      {String? policyHash, String? policyName, int? amount}) {
    return StakedNativeTokenInfo(
        policyHash: policyHash ?? this.policyHash,
        policyName: policyName ?? this.policyName,
        amount: amount ?? this.amount);
  }

  StakedNativeTokenInfo copyWithWrapped(
      {Wrapped<String>? policyHash,
      Wrapped<String>? policyName,
      Wrapped<int>? amount}) {
    return StakedNativeTokenInfo(
        policyHash: (policyHash != null ? policyHash.value : this.policyHash),
        policyName: (policyName != null ? policyName.value : this.policyName),
        amount: (amount != null ? amount.value : this.amount));
  }
}

@JsonSerializable(explicitToJson: true)
class StatusInABlock {
  const StatusInABlock({
    required this.date,
    required this.block,
  });

  factory StatusInABlock.fromJson(Map<String, dynamic> json) =>
      _$StatusInABlockFromJson(json);

  static const toJsonFactory = _$StatusInABlockToJson;
  Map<String, dynamic> toJson() => _$StatusInABlockToJson(this);

  @JsonKey(name: 'date')
  final BlockDate date;
  @JsonKey(name: 'block')
  final Hash block;
  static const fromJsonFactory = _$StatusInABlockFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StatusInABlock &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.block, block) ||
                const DeepCollectionEquality().equals(other.block, block)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(block) ^
      runtimeType.hashCode;
}

extension $StatusInABlockExtension on StatusInABlock {
  StatusInABlock copyWith({BlockDate? date, Hash? block}) {
    return StatusInABlock(date: date ?? this.date, block: block ?? this.block);
  }

  StatusInABlock copyWithWrapped(
      {Wrapped<BlockDate>? date, Wrapped<Hash>? block}) {
    return StatusInABlock(
        date: (date != null ? date.value : this.date),
        block: (block != null ? block.value : this.block));
  }
}

@JsonSerializable(explicitToJson: true)
class StatusPending {
  const StatusPending();

  factory StatusPending.fromJson(Map<String, dynamic> json) =>
      _$StatusPendingFromJson(json);

  static const toJsonFactory = _$StatusPendingToJson;
  Map<String, dynamic> toJson() => _$StatusPendingToJson(this);

  static const fromJsonFactory = _$StatusPendingFromJson;

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode => runtimeType.hashCode;
}

@JsonSerializable(explicitToJson: true)
class StatusRejected {
  const StatusRejected({
    required this.reason,
  });

  factory StatusRejected.fromJson(Map<String, dynamic> json) =>
      _$StatusRejectedFromJson(json);

  static const toJsonFactory = _$StatusRejectedToJson;
  Map<String, dynamic> toJson() => _$StatusRejectedToJson(this);

  @JsonKey(name: 'reason')
  final String reason;
  static const fromJsonFactory = _$StatusRejectedFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StatusRejected &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(reason) ^ runtimeType.hashCode;
}

extension $StatusRejectedExtension on StatusRejected {
  StatusRejected copyWith({String? reason}) {
    return StatusRejected(reason: reason ?? this.reason);
  }

  StatusRejected copyWithWrapped({Wrapped<String>? reason}) {
    return StatusRejected(
        reason: (reason != null ? reason.value : this.reason));
  }
}

@JsonSerializable(explicitToJson: true)
class SyncState {
  const SyncState({
    required this.slotNumber,
    required this.blockHash,
    required this.lastUpdated,
  });

  factory SyncState.fromJson(Map<String, dynamic> json) =>
      _$SyncStateFromJson(json);

  static const toJsonFactory = _$SyncStateToJson;
  Map<String, dynamic> toJson() => _$SyncStateToJson(this);

  @JsonKey(name: 'slot_number')
  final int slotNumber;
  @JsonKey(name: 'block_hash')
  final String blockHash;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  static const fromJsonFactory = _$SyncStateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SyncState &&
            (identical(other.slotNumber, slotNumber) ||
                const DeepCollectionEquality()
                    .equals(other.slotNumber, slotNumber)) &&
            (identical(other.blockHash, blockHash) ||
                const DeepCollectionEquality()
                    .equals(other.blockHash, blockHash)) &&
            (identical(other.lastUpdated, lastUpdated) ||
                const DeepCollectionEquality()
                    .equals(other.lastUpdated, lastUpdated)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(slotNumber) ^
      const DeepCollectionEquality().hash(blockHash) ^
      const DeepCollectionEquality().hash(lastUpdated) ^
      runtimeType.hashCode;
}

extension $SyncStateExtension on SyncState {
  SyncState copyWith(
      {int? slotNumber, String? blockHash, DateTime? lastUpdated}) {
    return SyncState(
        slotNumber: slotNumber ?? this.slotNumber,
        blockHash: blockHash ?? this.blockHash,
        lastUpdated: lastUpdated ?? this.lastUpdated);
  }

  SyncState copyWithWrapped(
      {Wrapped<int>? slotNumber,
      Wrapped<String>? blockHash,
      Wrapped<DateTime>? lastUpdated}) {
    return SyncState(
        slotNumber: (slotNumber != null ? slotNumber.value : this.slotNumber),
        blockHash: (blockHash != null ? blockHash.value : this.blockHash),
        lastUpdated:
            (lastUpdated != null ? lastUpdated.value : this.lastUpdated));
  }
}

@JsonSerializable(explicitToJson: true)
class ValidationError {
  const ValidationError({
    required this.message,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  static const toJsonFactory = _$ValidationErrorToJson;
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$ValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidationError &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $ValidationErrorExtension on ValidationError {
  ValidationError copyWith({String? message}) {
    return ValidationError(message: message ?? this.message);
  }

  ValidationError copyWithWrapped({Wrapped<String>? message}) {
    return ValidationError(
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class VotePlan {
  const VotePlan({
    required this.votingToken,
  });

  factory VotePlan.fromJson(Map<String, dynamic> json) =>
      _$VotePlanFromJson(json);

  static const toJsonFactory = _$VotePlanToJson;
  Map<String, dynamic> toJson() => _$VotePlanToJson(this);

  @JsonKey(name: 'voting_token')
  final String votingToken;
  static const fromJsonFactory = _$VotePlanFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VotePlan &&
            (identical(other.votingToken, votingToken) ||
                const DeepCollectionEquality()
                    .equals(other.votingToken, votingToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(votingToken) ^ runtimeType.hashCode;
}

extension $VotePlanExtension on VotePlan {
  VotePlan copyWith({String? votingToken}) {
    return VotePlan(votingToken: votingToken ?? this.votingToken);
  }

  VotePlan copyWithWrapped({Wrapped<String>? votingToken}) {
    return VotePlan(
        votingToken:
            (votingToken != null ? votingToken.value : this.votingToken));
  }
}

@JsonSerializable(explicitToJson: true)
class VoterInfo {
  const VoterInfo({
    required this.votingPower,
    required this.votingGroup,
    required this.delegationsPower,
    required this.delegationsCount,
    required this.votingPowerSaturation,
    this.delegatorAddresses,
  });

  factory VoterInfo.fromJson(Map<String, dynamic> json) =>
      _$VoterInfoFromJson(json);

  static const toJsonFactory = _$VoterInfoToJson;
  Map<String, dynamic> toJson() => _$VoterInfoToJson(this);

  @JsonKey(name: 'voting_power')
  final int votingPower;
  @JsonKey(
    name: 'voting_group',
    toJson: voterGroupIdToJson,
    fromJson: voterGroupIdFromJson,
  )
  final enums.VoterGroupId votingGroup;
  @JsonKey(name: 'delegations_power')
  final int delegationsPower;
  @JsonKey(name: 'delegations_count')
  final int delegationsCount;
  @JsonKey(name: 'voting_power_saturation')
  final double votingPowerSaturation;
  @JsonKey(name: 'delegator_addresses', defaultValue: <DelegatePublicKey>[])
  final List<DelegatePublicKey>? delegatorAddresses;
  static const fromJsonFactory = _$VoterInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VoterInfo &&
            (identical(other.votingPower, votingPower) ||
                const DeepCollectionEquality()
                    .equals(other.votingPower, votingPower)) &&
            (identical(other.votingGroup, votingGroup) ||
                const DeepCollectionEquality()
                    .equals(other.votingGroup, votingGroup)) &&
            (identical(other.delegationsPower, delegationsPower) ||
                const DeepCollectionEquality()
                    .equals(other.delegationsPower, delegationsPower)) &&
            (identical(other.delegationsCount, delegationsCount) ||
                const DeepCollectionEquality()
                    .equals(other.delegationsCount, delegationsCount)) &&
            (identical(other.votingPowerSaturation, votingPowerSaturation) ||
                const DeepCollectionEquality().equals(
                    other.votingPowerSaturation, votingPowerSaturation)) &&
            (identical(other.delegatorAddresses, delegatorAddresses) ||
                const DeepCollectionEquality()
                    .equals(other.delegatorAddresses, delegatorAddresses)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(votingPower) ^
      const DeepCollectionEquality().hash(votingGroup) ^
      const DeepCollectionEquality().hash(delegationsPower) ^
      const DeepCollectionEquality().hash(delegationsCount) ^
      const DeepCollectionEquality().hash(votingPowerSaturation) ^
      const DeepCollectionEquality().hash(delegatorAddresses) ^
      runtimeType.hashCode;
}

extension $VoterInfoExtension on VoterInfo {
  VoterInfo copyWith(
      {int? votingPower,
      enums.VoterGroupId? votingGroup,
      int? delegationsPower,
      int? delegationsCount,
      double? votingPowerSaturation,
      List<DelegatePublicKey>? delegatorAddresses}) {
    return VoterInfo(
        votingPower: votingPower ?? this.votingPower,
        votingGroup: votingGroup ?? this.votingGroup,
        delegationsPower: delegationsPower ?? this.delegationsPower,
        delegationsCount: delegationsCount ?? this.delegationsCount,
        votingPowerSaturation:
            votingPowerSaturation ?? this.votingPowerSaturation,
        delegatorAddresses: delegatorAddresses ?? this.delegatorAddresses);
  }

  VoterInfo copyWithWrapped(
      {Wrapped<int>? votingPower,
      Wrapped<enums.VoterGroupId>? votingGroup,
      Wrapped<int>? delegationsPower,
      Wrapped<int>? delegationsCount,
      Wrapped<double>? votingPowerSaturation,
      Wrapped<List<DelegatePublicKey>?>? delegatorAddresses}) {
    return VoterInfo(
        votingPower:
            (votingPower != null ? votingPower.value : this.votingPower),
        votingGroup:
            (votingGroup != null ? votingGroup.value : this.votingGroup),
        delegationsPower: (delegationsPower != null
            ? delegationsPower.value
            : this.delegationsPower),
        delegationsCount: (delegationsCount != null
            ? delegationsCount.value
            : this.delegationsCount),
        votingPowerSaturation: (votingPowerSaturation != null
            ? votingPowerSaturation.value
            : this.votingPowerSaturation),
        delegatorAddresses: (delegatorAddresses != null
            ? delegatorAddresses.value
            : this.delegatorAddresses));
  }
}

@JsonSerializable(explicitToJson: true)
class VoterRegistration {
  const VoterRegistration({
    required this.voterInfo,
    required this.asAt,
    required this.lastUpdated,
    required this.$final,
  });

  factory VoterRegistration.fromJson(Map<String, dynamic> json) =>
      _$VoterRegistrationFromJson(json);

  static const toJsonFactory = _$VoterRegistrationToJson;
  Map<String, dynamic> toJson() => _$VoterRegistrationToJson(this);

  @JsonKey(name: 'voter_info')
  final VoterInfo voterInfo;
  @JsonKey(name: 'as_at')
  final DateTime asAt;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  @JsonKey(name: 'final')
  final bool $final;
  static const fromJsonFactory = _$VoterRegistrationFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VoterRegistration &&
            (identical(other.voterInfo, voterInfo) ||
                const DeepCollectionEquality()
                    .equals(other.voterInfo, voterInfo)) &&
            (identical(other.asAt, asAt) ||
                const DeepCollectionEquality().equals(other.asAt, asAt)) &&
            (identical(other.lastUpdated, lastUpdated) ||
                const DeepCollectionEquality()
                    .equals(other.lastUpdated, lastUpdated)) &&
            (identical(other.$final, $final) ||
                const DeepCollectionEquality().equals(other.$final, $final)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(voterInfo) ^
      const DeepCollectionEquality().hash(asAt) ^
      const DeepCollectionEquality().hash(lastUpdated) ^
      const DeepCollectionEquality().hash($final) ^
      runtimeType.hashCode;
}

extension $VoterRegistrationExtension on VoterRegistration {
  VoterRegistration copyWith(
      {VoterInfo? voterInfo,
      DateTime? asAt,
      DateTime? lastUpdated,
      bool? $final}) {
    return VoterRegistration(
        voterInfo: voterInfo ?? this.voterInfo,
        asAt: asAt ?? this.asAt,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        $final: $final ?? this.$final);
  }

  VoterRegistration copyWithWrapped(
      {Wrapped<VoterInfo>? voterInfo,
      Wrapped<DateTime>? asAt,
      Wrapped<DateTime>? lastUpdated,
      Wrapped<bool>? $final}) {
    return VoterRegistration(
        voterInfo: (voterInfo != null ? voterInfo.value : this.voterInfo),
        asAt: (asAt != null ? asAt.value : this.asAt),
        lastUpdated:
            (lastUpdated != null ? lastUpdated.value : this.lastUpdated),
        $final: ($final != null ? $final.value : this.$final));
  }
}

@JsonSerializable(explicitToJson: true)
class VotingInfo {
  const VotingInfo();

  factory VotingInfo.fromJson(Map<String, dynamic> json) =>
      _$VotingInfoFromJson(json);

  static const toJsonFactory = _$VotingInfoToJson;
  Map<String, dynamic> toJson() => _$VotingInfoToJson(this);

  static const fromJsonFactory = _$VotingInfoFromJson;

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode => runtimeType.hashCode;
}

@JsonSerializable(explicitToJson: true)
class VotingInfoDelegations {
  const VotingInfoDelegations({
    required this.type,
    required this.delegations,
  });

  factory VotingInfoDelegations.fromJson(Map<String, dynamic> json) =>
      _$VotingInfoDelegationsFromJson(json);

  static const toJsonFactory = _$VotingInfoDelegationsToJson;
  Map<String, dynamic> toJson() => _$VotingInfoDelegationsToJson(this);

  @JsonKey(
    name: 'type',
    toJson: votingInfoDelegationsTypeToJson,
    fromJson: votingInfoDelegationsTypeFromJson,
  )
  final enums.VotingInfoDelegationsType type;
  @JsonKey(name: 'delegations', defaultValue: <Delegation>[])
  final List<Delegation> delegations;
  static const fromJsonFactory = _$VotingInfoDelegationsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VotingInfoDelegations &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.delegations, delegations) ||
                const DeepCollectionEquality()
                    .equals(other.delegations, delegations)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(delegations) ^
      runtimeType.hashCode;
}

extension $VotingInfoDelegationsExtension on VotingInfoDelegations {
  VotingInfoDelegations copyWith(
      {enums.VotingInfoDelegationsType? type, List<Delegation>? delegations}) {
    return VotingInfoDelegations(
        type: type ?? this.type, delegations: delegations ?? this.delegations);
  }

  VotingInfoDelegations copyWithWrapped(
      {Wrapped<enums.VotingInfoDelegationsType>? type,
      Wrapped<List<Delegation>>? delegations}) {
    return VotingInfoDelegations(
        type: (type != null ? type.value : this.type),
        delegations:
            (delegations != null ? delegations.value : this.delegations));
  }
}

@JsonSerializable(explicitToJson: true)
class VotingInfoDirectVoter {
  const VotingInfoDirectVoter({
    required this.type,
    required this.votingKey,
  });

  factory VotingInfoDirectVoter.fromJson(Map<String, dynamic> json) =>
      _$VotingInfoDirectVoterFromJson(json);

  static const toJsonFactory = _$VotingInfoDirectVoterToJson;
  Map<String, dynamic> toJson() => _$VotingInfoDirectVoterToJson(this);

  @JsonKey(
    name: 'type',
    toJson: votingInfoDirectVoterTypeToJson,
    fromJson: votingInfoDirectVoterTypeFromJson,
  )
  final enums.VotingInfoDirectVoterType type;
  @JsonKey(name: 'voting_key')
  final String votingKey;
  static const fromJsonFactory = _$VotingInfoDirectVoterFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VotingInfoDirectVoter &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.votingKey, votingKey) ||
                const DeepCollectionEquality()
                    .equals(other.votingKey, votingKey)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(votingKey) ^
      runtimeType.hashCode;
}

extension $VotingInfoDirectVoterExtension on VotingInfoDirectVoter {
  VotingInfoDirectVoter copyWith(
      {enums.VotingInfoDirectVoterType? type, String? votingKey}) {
    return VotingInfoDirectVoter(
        type: type ?? this.type, votingKey: votingKey ?? this.votingKey);
  }

  VotingInfoDirectVoter copyWithWrapped(
      {Wrapped<enums.VotingInfoDirectVoterType>? type,
      Wrapped<String>? votingKey}) {
    return VotingInfoDirectVoter(
        type: (type != null ? type.value : this.type),
        votingKey: (votingKey != null ? votingKey.value : this.votingKey));
  }
}

String? deepQueryInspectionFlagNullableToJson(
    enums.DeepQueryInspectionFlag? deepQueryInspectionFlag) {
  return deepQueryInspectionFlag?.value;
}

String? deepQueryInspectionFlagToJson(
    enums.DeepQueryInspectionFlag deepQueryInspectionFlag) {
  return deepQueryInspectionFlag.value;
}

enums.DeepQueryInspectionFlag deepQueryInspectionFlagFromJson(
  Object? deepQueryInspectionFlag, [
  enums.DeepQueryInspectionFlag? defaultValue,
]) {
  return enums.DeepQueryInspectionFlag.values
          .firstWhereOrNull((e) => e.value == deepQueryInspectionFlag) ??
      defaultValue ??
      enums.DeepQueryInspectionFlag.swaggerGeneratedUnknown;
}

enums.DeepQueryInspectionFlag? deepQueryInspectionFlagNullableFromJson(
  Object? deepQueryInspectionFlag, [
  enums.DeepQueryInspectionFlag? defaultValue,
]) {
  if (deepQueryInspectionFlag == null) {
    return null;
  }
  return enums.DeepQueryInspectionFlag.values
          .firstWhereOrNull((e) => e.value == deepQueryInspectionFlag) ??
      defaultValue;
}

String deepQueryInspectionFlagExplodedListToJson(
    List<enums.DeepQueryInspectionFlag>? deepQueryInspectionFlag) {
  return deepQueryInspectionFlag?.map((e) => e.value!).join(',') ?? '';
}

List<String> deepQueryInspectionFlagListToJson(
    List<enums.DeepQueryInspectionFlag>? deepQueryInspectionFlag) {
  if (deepQueryInspectionFlag == null) {
    return [];
  }

  return deepQueryInspectionFlag.map((e) => e.value!).toList();
}

List<enums.DeepQueryInspectionFlag> deepQueryInspectionFlagListFromJson(
  List? deepQueryInspectionFlag, [
  List<enums.DeepQueryInspectionFlag>? defaultValue,
]) {
  if (deepQueryInspectionFlag == null) {
    return defaultValue ?? [];
  }

  return deepQueryInspectionFlag
      .map((e) => deepQueryInspectionFlagFromJson(e.toString()))
      .toList();
}

List<enums.DeepQueryInspectionFlag>?
    deepQueryInspectionFlagNullableListFromJson(
  List? deepQueryInspectionFlag, [
  List<enums.DeepQueryInspectionFlag>? defaultValue,
]) {
  if (deepQueryInspectionFlag == null) {
    return defaultValue;
  }

  return deepQueryInspectionFlag
      .map((e) => deepQueryInspectionFlagFromJson(e.toString()))
      .toList();
}

String? logLevelNullableToJson(enums.LogLevel? logLevel) {
  return logLevel?.value;
}

String? logLevelToJson(enums.LogLevel logLevel) {
  return logLevel.value;
}

enums.LogLevel logLevelFromJson(
  Object? logLevel, [
  enums.LogLevel? defaultValue,
]) {
  return enums.LogLevel.values.firstWhereOrNull((e) => e.value == logLevel) ??
      defaultValue ??
      enums.LogLevel.swaggerGeneratedUnknown;
}

enums.LogLevel? logLevelNullableFromJson(
  Object? logLevel, [
  enums.LogLevel? defaultValue,
]) {
  if (logLevel == null) {
    return null;
  }
  return enums.LogLevel.values.firstWhereOrNull((e) => e.value == logLevel) ??
      defaultValue;
}

String logLevelExplodedListToJson(List<enums.LogLevel>? logLevel) {
  return logLevel?.map((e) => e.value!).join(',') ?? '';
}

List<String> logLevelListToJson(List<enums.LogLevel>? logLevel) {
  if (logLevel == null) {
    return [];
  }

  return logLevel.map((e) => e.value!).toList();
}

List<enums.LogLevel> logLevelListFromJson(
  List? logLevel, [
  List<enums.LogLevel>? defaultValue,
]) {
  if (logLevel == null) {
    return defaultValue ?? [];
  }

  return logLevel.map((e) => logLevelFromJson(e.toString())).toList();
}

List<enums.LogLevel>? logLevelNullableListFromJson(
  List? logLevel, [
  List<enums.LogLevel>? defaultValue,
]) {
  if (logLevel == null) {
    return defaultValue;
  }

  return logLevel.map((e) => logLevelFromJson(e.toString())).toList();
}

String? networkNullableToJson(enums.Network? network) {
  return network?.value;
}

String? networkToJson(enums.Network network) {
  return network.value;
}

enums.Network networkFromJson(
  Object? network, [
  enums.Network? defaultValue,
]) {
  return enums.Network.values.firstWhereOrNull((e) => e.value == network) ??
      defaultValue ??
      enums.Network.swaggerGeneratedUnknown;
}

enums.Network? networkNullableFromJson(
  Object? network, [
  enums.Network? defaultValue,
]) {
  if (network == null) {
    return null;
  }
  return enums.Network.values.firstWhereOrNull((e) => e.value == network) ??
      defaultValue;
}

String networkExplodedListToJson(List<enums.Network>? network) {
  return network?.map((e) => e.value!).join(',') ?? '';
}

List<String> networkListToJson(List<enums.Network>? network) {
  if (network == null) {
    return [];
  }

  return network.map((e) => e.value!).toList();
}

List<enums.Network> networkListFromJson(
  List? network, [
  List<enums.Network>? defaultValue,
]) {
  if (network == null) {
    return defaultValue ?? [];
  }

  return network.map((e) => networkFromJson(e.toString())).toList();
}

List<enums.Network>? networkNullableListFromJson(
  List? network, [
  List<enums.Network>? defaultValue,
]) {
  if (network == null) {
    return defaultValue;
  }

  return network.map((e) => networkFromJson(e.toString())).toList();
}

String? reasonRejectedNullableToJson(enums.ReasonRejected? reasonRejected) {
  return reasonRejected?.value;
}

String? reasonRejectedToJson(enums.ReasonRejected reasonRejected) {
  return reasonRejected.value;
}

enums.ReasonRejected reasonRejectedFromJson(
  Object? reasonRejected, [
  enums.ReasonRejected? defaultValue,
]) {
  return enums.ReasonRejected.values
          .firstWhereOrNull((e) => e.value == reasonRejected) ??
      defaultValue ??
      enums.ReasonRejected.swaggerGeneratedUnknown;
}

enums.ReasonRejected? reasonRejectedNullableFromJson(
  Object? reasonRejected, [
  enums.ReasonRejected? defaultValue,
]) {
  if (reasonRejected == null) {
    return null;
  }
  return enums.ReasonRejected.values
          .firstWhereOrNull((e) => e.value == reasonRejected) ??
      defaultValue;
}

String reasonRejectedExplodedListToJson(
    List<enums.ReasonRejected>? reasonRejected) {
  return reasonRejected?.map((e) => e.value!).join(',') ?? '';
}

List<String> reasonRejectedListToJson(
    List<enums.ReasonRejected>? reasonRejected) {
  if (reasonRejected == null) {
    return [];
  }

  return reasonRejected.map((e) => e.value!).toList();
}

List<enums.ReasonRejected> reasonRejectedListFromJson(
  List? reasonRejected, [
  List<enums.ReasonRejected>? defaultValue,
]) {
  if (reasonRejected == null) {
    return defaultValue ?? [];
  }

  return reasonRejected
      .map((e) => reasonRejectedFromJson(e.toString()))
      .toList();
}

List<enums.ReasonRejected>? reasonRejectedNullableListFromJson(
  List? reasonRejected, [
  List<enums.ReasonRejected>? defaultValue,
]) {
  if (reasonRejected == null) {
    return defaultValue;
  }

  return reasonRejected
      .map((e) => reasonRejectedFromJson(e.toString()))
      .toList();
}

String? voterGroupIdNullableToJson(enums.VoterGroupId? voterGroupId) {
  return voterGroupId?.value;
}

String? voterGroupIdToJson(enums.VoterGroupId voterGroupId) {
  return voterGroupId.value;
}

enums.VoterGroupId voterGroupIdFromJson(
  Object? voterGroupId, [
  enums.VoterGroupId? defaultValue,
]) {
  return enums.VoterGroupId.values
          .firstWhereOrNull((e) => e.value == voterGroupId) ??
      defaultValue ??
      enums.VoterGroupId.swaggerGeneratedUnknown;
}

enums.VoterGroupId? voterGroupIdNullableFromJson(
  Object? voterGroupId, [
  enums.VoterGroupId? defaultValue,
]) {
  if (voterGroupId == null) {
    return null;
  }
  return enums.VoterGroupId.values
          .firstWhereOrNull((e) => e.value == voterGroupId) ??
      defaultValue;
}

String voterGroupIdExplodedListToJson(List<enums.VoterGroupId>? voterGroupId) {
  return voterGroupId?.map((e) => e.value!).join(',') ?? '';
}

List<String> voterGroupIdListToJson(List<enums.VoterGroupId>? voterGroupId) {
  if (voterGroupId == null) {
    return [];
  }

  return voterGroupId.map((e) => e.value!).toList();
}

List<enums.VoterGroupId> voterGroupIdListFromJson(
  List? voterGroupId, [
  List<enums.VoterGroupId>? defaultValue,
]) {
  if (voterGroupId == null) {
    return defaultValue ?? [];
  }

  return voterGroupId.map((e) => voterGroupIdFromJson(e.toString())).toList();
}

List<enums.VoterGroupId>? voterGroupIdNullableListFromJson(
  List? voterGroupId, [
  List<enums.VoterGroupId>? defaultValue,
]) {
  if (voterGroupId == null) {
    return defaultValue;
  }

  return voterGroupId.map((e) => voterGroupIdFromJson(e.toString())).toList();
}

String? votingInfoDelegationsTypeNullableToJson(
    enums.VotingInfoDelegationsType? votingInfoDelegationsType) {
  return votingInfoDelegationsType?.value;
}

String? votingInfoDelegationsTypeToJson(
    enums.VotingInfoDelegationsType votingInfoDelegationsType) {
  return votingInfoDelegationsType.value;
}

enums.VotingInfoDelegationsType votingInfoDelegationsTypeFromJson(
  Object? votingInfoDelegationsType, [
  enums.VotingInfoDelegationsType? defaultValue,
]) {
  return enums.VotingInfoDelegationsType.values
          .firstWhereOrNull((e) => e.value == votingInfoDelegationsType) ??
      defaultValue ??
      enums.VotingInfoDelegationsType.swaggerGeneratedUnknown;
}

enums.VotingInfoDelegationsType? votingInfoDelegationsTypeNullableFromJson(
  Object? votingInfoDelegationsType, [
  enums.VotingInfoDelegationsType? defaultValue,
]) {
  if (votingInfoDelegationsType == null) {
    return null;
  }
  return enums.VotingInfoDelegationsType.values
          .firstWhereOrNull((e) => e.value == votingInfoDelegationsType) ??
      defaultValue;
}

String votingInfoDelegationsTypeExplodedListToJson(
    List<enums.VotingInfoDelegationsType>? votingInfoDelegationsType) {
  return votingInfoDelegationsType?.map((e) => e.value!).join(',') ?? '';
}

List<String> votingInfoDelegationsTypeListToJson(
    List<enums.VotingInfoDelegationsType>? votingInfoDelegationsType) {
  if (votingInfoDelegationsType == null) {
    return [];
  }

  return votingInfoDelegationsType.map((e) => e.value!).toList();
}

List<enums.VotingInfoDelegationsType> votingInfoDelegationsTypeListFromJson(
  List? votingInfoDelegationsType, [
  List<enums.VotingInfoDelegationsType>? defaultValue,
]) {
  if (votingInfoDelegationsType == null) {
    return defaultValue ?? [];
  }

  return votingInfoDelegationsType
      .map((e) => votingInfoDelegationsTypeFromJson(e.toString()))
      .toList();
}

List<enums.VotingInfoDelegationsType>?
    votingInfoDelegationsTypeNullableListFromJson(
  List? votingInfoDelegationsType, [
  List<enums.VotingInfoDelegationsType>? defaultValue,
]) {
  if (votingInfoDelegationsType == null) {
    return defaultValue;
  }

  return votingInfoDelegationsType
      .map((e) => votingInfoDelegationsTypeFromJson(e.toString()))
      .toList();
}

String? votingInfoDirectVoterTypeNullableToJson(
    enums.VotingInfoDirectVoterType? votingInfoDirectVoterType) {
  return votingInfoDirectVoterType?.value;
}

String? votingInfoDirectVoterTypeToJson(
    enums.VotingInfoDirectVoterType votingInfoDirectVoterType) {
  return votingInfoDirectVoterType.value;
}

enums.VotingInfoDirectVoterType votingInfoDirectVoterTypeFromJson(
  Object? votingInfoDirectVoterType, [
  enums.VotingInfoDirectVoterType? defaultValue,
]) {
  return enums.VotingInfoDirectVoterType.values
          .firstWhereOrNull((e) => e.value == votingInfoDirectVoterType) ??
      defaultValue ??
      enums.VotingInfoDirectVoterType.swaggerGeneratedUnknown;
}

enums.VotingInfoDirectVoterType? votingInfoDirectVoterTypeNullableFromJson(
  Object? votingInfoDirectVoterType, [
  enums.VotingInfoDirectVoterType? defaultValue,
]) {
  if (votingInfoDirectVoterType == null) {
    return null;
  }
  return enums.VotingInfoDirectVoterType.values
          .firstWhereOrNull((e) => e.value == votingInfoDirectVoterType) ??
      defaultValue;
}

String votingInfoDirectVoterTypeExplodedListToJson(
    List<enums.VotingInfoDirectVoterType>? votingInfoDirectVoterType) {
  return votingInfoDirectVoterType?.map((e) => e.value!).join(',') ?? '';
}

List<String> votingInfoDirectVoterTypeListToJson(
    List<enums.VotingInfoDirectVoterType>? votingInfoDirectVoterType) {
  if (votingInfoDirectVoterType == null) {
    return [];
  }

  return votingInfoDirectVoterType.map((e) => e.value!).toList();
}

List<enums.VotingInfoDirectVoterType> votingInfoDirectVoterTypeListFromJson(
  List? votingInfoDirectVoterType, [
  List<enums.VotingInfoDirectVoterType>? defaultValue,
]) {
  if (votingInfoDirectVoterType == null) {
    return defaultValue ?? [];
  }

  return votingInfoDirectVoterType
      .map((e) => votingInfoDirectVoterTypeFromJson(e.toString()))
      .toList();
}

List<enums.VotingInfoDirectVoterType>?
    votingInfoDirectVoterTypeNullableListFromJson(
  List? votingInfoDirectVoterType, [
  List<enums.VotingInfoDirectVoterType>? defaultValue,
]) {
  if (votingInfoDirectVoterType == null) {
    return defaultValue;
  }

  return votingInfoDirectVoterType
      .map((e) => votingInfoDirectVoterTypeFromJson(e.toString()))
      .toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
