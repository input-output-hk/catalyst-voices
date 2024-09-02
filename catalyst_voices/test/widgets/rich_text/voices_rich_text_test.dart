import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(VoicesRichText, () {
    testWidgets('renders correctly', (tester) async {
      // Given
      final widget = MaterialApp(home: VoicesRichText(document: Document.fromJson([]),));

      // When
      await tester.pumpWidget(widget);

      // Then
      expect(find.byType(QuillEditor), findsOneWidget);
      expect(find.byType(QuillToolbar), findsOneWidget);
    });
  });
}
