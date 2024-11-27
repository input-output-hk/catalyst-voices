import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/images/voices_image_scheme.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('EmptyState Widget Tests', () {
    testWidgets('Renders correctly with default values', (tester) async {
      await tester.pumpApp(
        const EmptyState(),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CatalystSvgPicture), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
      expect(find.text('No draft proposals yet'), findsOneWidget);
      expect(
        find.text(
          // ignore: lines_longer_than_80_chars
          'Discovery space will show draft proposals you can comment on, currently there are no draft proposals.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Renders correctly with custom values', (tester) async {
      await tester.pumpApp(
        const EmptyState(
          title: 'Custom Title',
          description: 'Custom Description',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CatalystSvgPicture), findsOneWidget);
      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Custom Description'), findsOneWidget);
    });

    testWidgets('Uses correct custom color scheme', (tester) async {
      const colors =
          VoicesColorScheme.optional(textOnPrimaryLevel1: Colors.red);
      await tester.pumpApp(
        voicesColors: colors,
        const EmptyState(
          title: 'Custom Title',
          description: 'Custom Description',
        ),
      );
      await tester.pumpAndSettle();

      final titleText = tester.widget<Text>(
        find.byType(Text).first,
      );

      expect(
        titleText.style?.color,
        colors.textOnPrimaryLevel1,
      );

      final descriptionText = tester.widget<Text>(
        find.byType(Text).last,
      );

      expect(
        descriptionText.style?.color,
        colors.textOnPrimaryLevel1,
      );
    });

    testWidgets(
      'Proposal image changes depending on theme brightness',
      (tester) async {
        // Given
        const widget = EmptyState();

        // When - Light theme
        await tester.pumpApp(
          widget,
          theme: ThemeData(brightness: Brightness.light),
          voicesColors: const VoicesColorScheme.optional(),
        );
        await tester.pumpAndSettle();

        // Then - Light theme
        final lightThemeImage = tester.widget<CatalystSvgPicture>(
          find.byType(CatalystSvgPicture),
        );
        expect(
          lightThemeImage,
          isA<CatalystSvgPicture>(),
        );

        // When - Dark theme
        await tester.pumpApp(
          widget,
          theme: ThemeData(brightness: Brightness.dark),
          voicesColors: const VoicesColorScheme.optional(),
        );
        await tester.pumpAndSettle();

        // Then - Dark theme
        final darkThemeImage = tester.widget<CatalystSvgPicture>(
          find.byType(CatalystSvgPicture),
        );
        expect(
          darkThemeImage,
          isA<CatalystSvgPicture>(),
        );
      },
    );

    testWidgets('Renders correctly with custom image', (tester) async {
      await tester.pumpApp(
        EmptyState(
          image: CatalystSvgPicture.asset(
            VoicesAssets.images.noProposalForeground.path,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CatalystSvgPicture), findsOneWidget);
      expect(find.byType(VoicesImagesScheme), findsNothing);
    });
  });
}
