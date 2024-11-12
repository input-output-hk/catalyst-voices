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
class ContentErrorDetail {
  const ContentErrorDetail({
    this.loc,
    this.msg,
    this.type,
  });

  factory ContentErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ContentErrorDetailFromJson(json);

  static const toJsonFactory = _$ContentErrorDetailToJson;
  Map<String, dynamic> toJson() => _$ContentErrorDetailToJson(this);

  @JsonKey(name: 'loc', defaultValue: <String>[])
  final List<String>? loc;
  @JsonKey(name: 'msg')
  final String? msg;
  @JsonKey(name: 'type')
  final String? type;
  static const fromJsonFactory = _$ContentErrorDetailFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ContentErrorDetail &&
            (identical(other.loc, loc) ||
                const DeepCollectionEquality().equals(other.loc, loc)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(loc) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(type) ^
      runtimeType.hashCode;
}

extension $ContentErrorDetailExtension on ContentErrorDetail {
  ContentErrorDetail copyWith({List<String>? loc, String? msg, String? type}) {
    return ContentErrorDetail(
        loc: loc ?? this.loc, msg: msg ?? this.msg, type: type ?? this.type);
  }

  ContentErrorDetail copyWithWrapped(
      {Wrapped<List<String>?>? loc,
      Wrapped<String?>? msg,
      Wrapped<String?>? type}) {
    return ContentErrorDetail(
        loc: (loc != null ? loc.value : this.loc),
        msg: (msg != null ? msg.value : this.msg),
        type: (type != null ? type.value : this.type));
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
class Forbidden {
  const Forbidden({
    required this.id,
    required this.msg,
    this.required,
  });

  factory Forbidden.fromJson(Map<String, dynamic> json) =>
      _$ForbiddenFromJson(json);

  static const toJsonFactory = _$ForbiddenToJson;
  Map<String, dynamic> toJson() => _$ForbiddenToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'required', defaultValue: <String>[])
  final List<String>? required;
  static const fromJsonFactory = _$ForbiddenFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Forbidden &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.required, required) ||
                const DeepCollectionEquality()
                    .equals(other.required, required)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(required) ^
      runtimeType.hashCode;
}

extension $ForbiddenExtension on Forbidden {
  Forbidden copyWith({String? id, String? msg, List<String>? required}) {
    return Forbidden(
        id: id ?? this.id,
        msg: msg ?? this.msg,
        required: required ?? this.required);
  }

  Forbidden copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? msg,
      Wrapped<List<String>?>? required}) {
    return Forbidden(
        id: (id != null ? id.value : this.id),
        msg: (msg != null ? msg.value : this.msg),
        required: (required != null ? required.value : this.required));
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
class InternalServerError {
  const InternalServerError({
    required this.id,
    required this.msg,
    this.issue,
  });

  factory InternalServerError.fromJson(Map<String, dynamic> json) =>
      _$InternalServerErrorFromJson(json);

  static const toJsonFactory = _$InternalServerErrorToJson;
  Map<String, dynamic> toJson() => _$InternalServerErrorToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'issue')
  final String? issue;
  static const fromJsonFactory = _$InternalServerErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InternalServerError &&
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

extension $InternalServerErrorExtension on InternalServerError {
  InternalServerError copyWith({String? id, String? msg, String? issue}) {
    return InternalServerError(
        id: id ?? this.id, msg: msg ?? this.msg, issue: issue ?? this.issue);
  }

  InternalServerError copyWithWrapped(
      {Wrapped<String>? id, Wrapped<String>? msg, Wrapped<String?>? issue}) {
    return InternalServerError(
        id: (id != null ? id.value : this.id),
        msg: (msg != null ? msg.value : this.msg),
        issue: (issue != null ? issue.value : this.issue));
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
class ServiceUnavailable {
  const ServiceUnavailable({
    required this.id,
    required this.msg,
  });

  factory ServiceUnavailable.fromJson(Map<String, dynamic> json) =>
      _$ServiceUnavailableFromJson(json);

  static const toJsonFactory = _$ServiceUnavailableToJson;
  Map<String, dynamic> toJson() => _$ServiceUnavailableToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'msg')
  final String msg;
  static const fromJsonFactory = _$ServiceUnavailableFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ServiceUnavailable &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(msg) ^
      runtimeType.hashCode;
}

extension $ServiceUnavailableExtension on ServiceUnavailable {
  ServiceUnavailable copyWith({String? id, String? msg}) {
    return ServiceUnavailable(id: id ?? this.id, msg: msg ?? this.msg);
  }

  ServiceUnavailable copyWithWrapped(
      {Wrapped<String>? id, Wrapped<String>? msg}) {
    return ServiceUnavailable(
        id: (id != null ? id.value : this.id),
        msg: (msg != null ? msg.value : this.msg));
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
class TooManyRequests {
  const TooManyRequests({
    required this.id,
    required this.msg,
  });

  factory TooManyRequests.fromJson(Map<String, dynamic> json) =>
      _$TooManyRequestsFromJson(json);

  static const toJsonFactory = _$TooManyRequestsToJson;
  Map<String, dynamic> toJson() => _$TooManyRequestsToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'msg')
  final String msg;
  static const fromJsonFactory = _$TooManyRequestsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TooManyRequests &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(msg) ^
      runtimeType.hashCode;
}

extension $TooManyRequestsExtension on TooManyRequests {
  TooManyRequests copyWith({String? id, String? msg}) {
    return TooManyRequests(id: id ?? this.id, msg: msg ?? this.msg);
  }

  TooManyRequests copyWithWrapped({Wrapped<String>? id, Wrapped<String>? msg}) {
    return TooManyRequests(
        id: (id != null ? id.value : this.id),
        msg: (msg != null ? msg.value : this.msg));
  }
}

@JsonSerializable(explicitToJson: true)
class Unauthorized {
  const Unauthorized({
    required this.id,
    required this.msg,
  });

  factory Unauthorized.fromJson(Map<String, dynamic> json) =>
      _$UnauthorizedFromJson(json);

  static const toJsonFactory = _$UnauthorizedToJson;
  Map<String, dynamic> toJson() => _$UnauthorizedToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'msg')
  final String msg;
  static const fromJsonFactory = _$UnauthorizedFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Unauthorized &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(msg) ^
      runtimeType.hashCode;
}

extension $UnauthorizedExtension on Unauthorized {
  Unauthorized copyWith({String? id, String? msg}) {
    return Unauthorized(id: id ?? this.id, msg: msg ?? this.msg);
  }

  Unauthorized copyWithWrapped({Wrapped<String>? id, Wrapped<String>? msg}) {
    return Unauthorized(
        id: (id != null ? id.value : this.id),
        msg: (msg != null ? msg.value : this.msg));
  }
}

@JsonSerializable(explicitToJson: true)
class UnprocessableContent {
  const UnprocessableContent({
    required this.detail,
  });

  factory UnprocessableContent.fromJson(Map<String, dynamic> json) =>
      _$UnprocessableContentFromJson(json);

  static const toJsonFactory = _$UnprocessableContentToJson;
  Map<String, dynamic> toJson() => _$UnprocessableContentToJson(this);

  @JsonKey(name: 'detail', defaultValue: <ContentErrorDetail>[])
  final List<ContentErrorDetail> detail;
  static const fromJsonFactory = _$UnprocessableContentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UnprocessableContent &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(detail) ^ runtimeType.hashCode;
}

extension $UnprocessableContentExtension on UnprocessableContent {
  UnprocessableContent copyWith({List<ContentErrorDetail>? detail}) {
    return UnprocessableContent(detail: detail ?? this.detail);
  }

  UnprocessableContent copyWithWrapped(
      {Wrapped<List<ContentErrorDetail>>? detail}) {
    return UnprocessableContent(
        detail: (detail != null ? detail.value : this.detail));
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
