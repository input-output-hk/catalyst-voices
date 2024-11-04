import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(VoicesRichText, () {
    testWidgets('renders correctly', (tester) async {
      // Given
      const widget = VoicesRichText();

      // When
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(QuillEditor), findsOneWidget);
    });
  });
}
