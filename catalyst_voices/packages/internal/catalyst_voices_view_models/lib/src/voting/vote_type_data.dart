import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class VoteTypeData extends Equatable implements Comparable<VoteTypeData> {
  final VoteType type;

  const VoteTypeData({
    required this.type,
  });

  DateTime? get castedAt;

  bool get isCasted => this is VoteTypeDataCasted;

  bool get isDraft => this is VoteTypeDataDraft;

  @override
  int compareTo(VoteTypeData other) {
    final instance = this;

    if (instance is VoteTypeDataCasted && other is VoteTypeDataCasted) {
      return instance.castedAt.compareTo(other.castedAt);
    }

    if (instance is VoteTypeDataCasted && other is VoteTypeDataDraft) {
      return 1;
    }

    if (instance is VoteTypeDataDraft && other is VoteTypeDataCasted) {
      return -1;
    }

    return 0;
  }
}

final class VoteTypeDataCasted extends VoteTypeData {
  @override
  final DateTime castedAt;

  const VoteTypeDataCasted({
    required super.type,
    required this.castedAt,
  });

  @override
  List<Object?> get props => [type, castedAt];
}

final class VoteTypeDataDraft extends VoteTypeData {
  const VoteTypeDataDraft({
    required super.type,
  });

  @override
  DateTime? get castedAt => null;

  @override
  List<Object?> get props => [type];
}
