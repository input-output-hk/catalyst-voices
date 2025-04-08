import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_submission_action_dto.g.dart';

@JsonSerializable()
final class ProposalSubmissionActionDocumentDto {
  final ProposalSubmissionActionDto action;

  const ProposalSubmissionActionDocumentDto({required this.action});

  factory ProposalSubmissionActionDocumentDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return _$ProposalSubmissionActionDocumentDtoFromJson(json);
  }

  Map<String, dynamic> toJson() =>
      _$ProposalSubmissionActionDocumentDtoToJson(this);
}

/// See [ProposalSubmissionAction].
enum ProposalSubmissionActionDto {
  @JsonValue('final')
  aFinal,
  @JsonValue('draft')
  draft,
  @JsonValue('hide')
  hide;

  factory ProposalSubmissionActionDto.fromModel(
    ProposalSubmissionAction action,
  ) {
    switch (action) {
      case ProposalSubmissionAction.aFinal:
        return ProposalSubmissionActionDto.aFinal;
      case ProposalSubmissionAction.draft:
        return ProposalSubmissionActionDto.draft;
      case ProposalSubmissionAction.hide:
        return ProposalSubmissionActionDto.hide;
    }
  }

  ProposalSubmissionAction toModel() {
    switch (this) {
      case ProposalSubmissionActionDto.aFinal:
        return ProposalSubmissionAction.aFinal;
      case ProposalSubmissionActionDto.draft:
        return ProposalSubmissionAction.draft;
      case ProposalSubmissionActionDto.hide:
        return ProposalSubmissionAction.hide;
    }
  }

  static ProposalSubmissionActionDto? fromJson(String value) {
    return $enumDecodeNullable(
      _$ProposalSubmissionActionDtoEnumMap,
      value,
      unknownValue: JsonKey.nullForUndefinedEnumValue,
    );
  }
}
