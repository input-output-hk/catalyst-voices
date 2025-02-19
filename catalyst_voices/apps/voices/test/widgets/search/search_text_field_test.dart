import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/src/themes/catalyst.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group(SearchTextField, () {
    const hintText = 'Search...';

    testWidgets(
      'renders correctly with default values and search icon',
      (tester) async {
        await tester.pumpApp(
          Material(
            child: SearchTextField(
              hintText: hintText,
              onSearch: ({
                required String searchValue,
                required bool isSubmitted,
              }) {},
            ),
          ),
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        expect(find.text(hintText), findsOneWidget);
        expect(find.byType(SearchTextField), findsOneWidget);
        expect(find.byType(CatalystSvgIcon), findsOneWidget);
      },
    );

    testWidgets(
      'calls onSearch with correct values when text is entered',
      (tester) async {
        String? lastSearchValue;
        bool? lastIsSubmitted;

        await tester.pumpApp(
          Material(
            child: SearchTextField(
              hintText: hintText,
              onSearch: ({
                required String searchValue,
                required bool isSubmitted,
              }) {
                lastSearchValue = searchValue;
                lastIsSubmitted = isSubmitted;
              },
            ),
          ),
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'test query');
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        expect(lastSearchValue, equals('test query'));
        expect(lastIsSubmitted, isFalse);
      },
    );

    testWidgets(
      'calls onSearch with isSubmitted=true when done is pressed',
      (tester) async {
        String? lastSearchValue;
        bool? lastIsSubmitted;

        await tester.pumpApp(
          Material(
            child: SearchTextField(
              hintText: hintText,
              onSearch: ({
                required String searchValue,
                required bool isSubmitted,
              }) {
                lastSearchValue = searchValue;
                lastIsSubmitted = isSubmitted;
              },
            ),
          ),
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'test query');
        await tester.pump(const Duration(milliseconds: 500));
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(lastSearchValue, equals('test query'));
        expect(lastIsSubmitted, isTrue);
      },
    );

    testWidgets(
      'calls onSearch with isSubmitted=true',
      (tester) async {
        String? lastSearchValue;
        bool? lastIsSubmitted;

        await tester.pumpApp(
          Material(
            child: SearchTextField(
              hintText: hintText,
              onSearch: ({
                required String searchValue,
                required bool isSubmitted,
              }) {
                lastSearchValue = searchValue;
                lastIsSubmitted = isSubmitted;
              },
            ),
          ),
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'test query');
        await tester.pump(const Duration(milliseconds: 500));
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        expect(lastSearchValue, equals('test query'));
        expect(lastIsSubmitted, isTrue);
      },
    );

    testWidgets(
      'respects custom width and height constraints',
      (tester) async {
        const customWidth = 300.0;
        const customHeight = 48.0;

        await tester.pumpApp(
          Material(
            child: SearchTextField(
              hintText: hintText,
              width: customWidth,
              height: customHeight,
              onSearch: ({
                required String searchValue,
                required bool isSubmitted,
              }) {},
            ),
          ),
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        final constrainedBox = find
            .descendant(
              of: find.byType(SearchTextField),
              matching: find.byType(ConstrainedBox),
            )
            .first;

        final widget = tester.widget<ConstrainedBox>(constrainedBox);
        expect(widget.constraints.maxWidth, customWidth);
        expect(widget.constraints.maxHeight, customHeight);
      },
    );
  });

  testWidgets(
    'reset button visibility and functionality',
    (tester) async {
      String? lastSearchValue;

      await tester.pumpApp(
        Material(
          child: SearchTextField(
            hintText: 'Search...',
            showClearButton: true,
            onSearch: ({
              required String searchValue,
              required bool isSubmitted,
            }) {
              lastSearchValue = searchValue;
            },
          ),
        ),
        voicesColors: lightVoicesColorScheme,
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('SearchTextFieldResetButton')), findsNothing);

      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(
        find.byKey(const Key('SearchTextFieldResetButton')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('SearchTextFieldResetButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(lastSearchValue, '');
      expect(find.byKey(const Key('SearchTextFieldResetButton')), findsNothing);
    },
  );

  testWidgets(
    'reset button remains hidden when showClearButton is false',
    (tester) async {
      await tester.pumpApp(
        Material(
          child: SearchTextField(
            hintText: 'Search...',
            showClearButton: false,
            onSearch: ({
              required String searchValue,
              required bool isSubmitted,
            }) {},
          ),
        ),
        voicesColors: lightVoicesColorScheme,
      );
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Reset button should remain hidden
      expect(find.text('reset'), findsNothing);
    },
  );
}
