import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(VoicesDocumentsTemplates, () {
    group('proposalF14', () {
      test('schema', () async {
        final json = await VoicesDocumentsTemplates.proposalF14Schema;

        expect(json, isNotEmpty);
      });

      test('document', () async {
        final json = await VoicesDocumentsTemplates.proposalF14Document;

        expect(json, isNotEmpty);
      });
    });
  });
}
