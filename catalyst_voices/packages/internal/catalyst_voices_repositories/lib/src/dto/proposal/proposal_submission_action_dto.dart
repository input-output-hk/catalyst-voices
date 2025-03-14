import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_submission_action_dto.g.dart';

@JsonSerializable()
final class ProposalSubmissionActionDocumentDto
    implements SignedDocumentPayload {
  final ProposalSubmissionActionDto action;

  const ProposalSubmissionActionDocumentDto({required this.action});

  factory ProposalSubmissionActionDocumentDto.fromBytes(Uint8List bytes) {
    final decoded = json.fuse(utf8).decode(bytes);

    return ProposalSubmissionActionDocumentDto.fromJson(
      decoded! as Map<String, dynamic>,
    );
  }

  factory ProposalSubmissionActionDocumentDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return _$ProposalSubmissionActionDocumentDtoFromJson(json);
  }

  @override
  Uint8List toBytes() => Uint8List.fromList(json.fuse(utf8).encode(toJson()));

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
}
