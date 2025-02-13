import 'package:catalyst_voices/widgets/rich_text/voices_rich_text_rules.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(AutoAlwaysExitBlockRule, () {
    late quill.Document document;
    late AutoAlwaysExitBlockRule rule;

    setUp(() {
      document = quill.Document.fromDelta(
        Delta.fromOperations([
          Operation.insert('Hello\n', {'list': 'bullet'}),
          Operation.insert('\n', {'list': 'bullet'}),
          Operation.insert('World\n', {'list': 'bullet'}),
          Operation.insert('\n', {'list': 'bullet'}),
        ]),
      );
      rule = const AutoAlwaysExitBlockRule();
    });

    test('Does not exit block when inserting a single newline', () {
      final delta = rule.applyRule(document, 12, data: '\n');
      expect(delta, isNull);
    });

    test('Exits block even if it is in the middle of the block', () {
      final delta = rule.applyRule(document, 6, data: '\n');
      expect(delta, isNotNull);
      expect(delta!.operations.length, 2);
      expect(delta.operations[1].attributes, equals({'list': null}));
    });

    test('Does nothing if newline is inserted outside a block', () {
      final delta = rule.applyRule(document, 5, data: '\n');
      expect(delta, isNull);
    });

    test('Exits block when inserting a second consecutive newline', () {
      final delta = rule.applyRule(document, 13, data: '\n');
      expect(delta, isNotNull);
      expect(delta!.operations.length, 2);
      expect(delta.operations[1].attributes, equals({'list': null}));
    });
  });
}
