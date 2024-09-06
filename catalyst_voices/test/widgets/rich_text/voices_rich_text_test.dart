import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(VoicesRichText, () {
    testWidgets('renders correctly', (tester) async {
      // Given
      final widget = MaterialApp(
        theme: ThemeBuilder.buildTheme(BrandKey.catalyst),
        localizationsDelegates: const [
          ...VoicesLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate(),
        ],
        home: VoicesRichText(),
      );

      // When
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(QuillEditor), findsOneWidget);
    });
  });
}
