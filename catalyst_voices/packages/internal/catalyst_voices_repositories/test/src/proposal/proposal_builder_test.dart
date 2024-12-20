import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal_builder_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/schema_dto.dart';
import 'package:test/test.dart';

import '../../helpers/read_json.dart';

void main() {
  const schemaPath =
      'test/assets/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json';

  late Map<String, dynamic> schemaJson;

  setUpAll(() {
    schemaJson = json.decode(readJson(schemaPath)) as Map<String, dynamic>;
  });

  test('Converts segments list into object for JSON', () {
    final schemaDto = SchemaDto.fromJson(schemaJson);
    final schema = schemaDto.toModel();

    final proposalBuilder = ProposalBuilder.build(schema);
    final proposalBuilderDto = ProposalBuilderDto.fromModel(proposalBuilder);
    final proposalBuilderJson = proposalBuilderDto.toJson();

    for (final segment in proposalBuilderDto.segments) {
      expect(proposalBuilderJson[segment.id], isA<Map<String, dynamic>>());
    }
  });

  test('Converts object from JSON into List of segments', () {
    final schemaDto = SchemaDto.fromJson(schemaJson);
    final schema = schemaDto.toModel();

    final proposalBuilder = ProposalBuilder.build(schema);
    final proposalBuilderDto = ProposalBuilderDto.fromModel(proposalBuilder);

    final proposalBuilderJson = proposalBuilderDto.toJson();
    final proposalBuilderDtoFromJson =
        ProposalBuilderDto.fromJson(proposalBuilderJson);

    expect(
      proposalBuilderDtoFromJson.segments.length,
      proposalBuilderDto.segments.length,
    );
  });
}
