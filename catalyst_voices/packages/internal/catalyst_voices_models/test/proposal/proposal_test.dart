import 'dart:convert';

import 'package:catalyst_voices_models/src/proposal/proposal_template/proposal_template.dart';
import 'package:test/test.dart';

import 'helpers/read_json.dart';

Future<void> main() async {
  const filePath = '/test/proposal/helpers/generic_proposal_template.json';
  late Map<String, dynamic> template;

  setUpAll(() {
    template = json.decode(readJson(filePath)) as Map<String, dynamic>;
  });

  test('Test proposal template', () async {
    final proposalTemplate = PropTemplate.fromJson(template);
  });
}
