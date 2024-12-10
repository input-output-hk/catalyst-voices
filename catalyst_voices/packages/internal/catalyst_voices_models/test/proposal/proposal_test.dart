import 'dart:convert';

import 'package:catalyst_voices_models/src/proposal_template/dtos/proposal_template_dto.dart';
import 'package:test/test.dart';

import 'helpers/read_json.dart';

Future<void> main() async {
  const filePath =
      '/test/proposal/helpers/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json';
  late Map<String, dynamic> template;

  setUpAll(() {
    template = json.decode(readJson(filePath)) as Map<String, dynamic>;
  });

  test('Test proposal template', () async {
    final proposalTemplate = ProposalTemplateDTO.fromJson(template);

    final json = proposalTemplate.toJson();
    print(jsonEncode(json).toString());
  });
}
