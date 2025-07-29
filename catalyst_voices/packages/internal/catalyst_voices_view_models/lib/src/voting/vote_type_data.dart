import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class VoteTypeData extends Equatable {
  final VoteType type;

  const VoteTypeData({
    required this.type,
  });

  DateTime? get castedAt;

  bool get isCasted => this is VoteTypeDataCasted;

  bool get isDraft => this is VoteTypeDataDraft;
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
