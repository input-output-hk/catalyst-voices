import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/src/brand/brand_bloc.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const catalystKey = Key('C');
  const fallbackKey = Key('F');

  Widget buildApp() => BlocProvider(
    create: (context) => BrandBloc(),
    child: BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        return MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Row(
                children: [
                  MaterialButton(
                    key: catalystKey,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      context.read<BrandBloc>().add(
                        const BrandChangedEvent(BrandKey.catalyst),
                      );
                    },
                    child: const Text('Catalyst'),
                  ),
                  MaterialButton(
                    key: fallbackKey,
                    color: Theme.of(context).primaryColor,
                    child: const Text('Fallback'),
                    onPressed: () {
                      context.read<BrandBloc>().add(
                        const BrandChangedEvent(BrandKey.fallback),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          theme: ThemeBuilder.buildTheme(state.brandKey),
          darkTheme: ThemeBuilder.buildTheme(state.brandKey),
        );
      },
    ),
  );

  group('Test brands', () {

    // Colors used in the Brand themes as primary. They are used for
    // the color of the widgets we are testing and they are the colors
    // we will check against to ensure correct rendering.
    final fallbackColor = ThemeData(useMaterial3: true).primaryColor;
    const catalystColor = VoicesColors.lightPrimary;

    testWidgets('Default Catalyst theme is applied', (tester) async {
      await tester.pumpWidget(
        buildApp(),
      );

      final catalystButton = find.byKey(catalystKey);
      final fallbackButton = find.byKey(fallbackKey);

      expect(catalystButton, findsOneWidget);
      expect(fallbackButton, findsOneWidget);
      expect(
        tester.widget<MaterialButton>(catalystButton).color,
        catalystColor,
      );
      expect(
        tester.widget<MaterialButton>(fallbackButton).color,
        catalystColor,
      );
    });
    testWidgets('Fallback Theme is applied after switch', (tester) async {
      await tester.pumpWidget(
        buildApp(),
      );

      final catalystButton = find.byKey(catalystKey);
      final fallbackButton = find.byKey(fallbackKey);

      expect(catalystButton, findsOneWidget);
      expect(fallbackButton, findsOneWidget);
      
      await tester.tap(fallbackButton);
      // We need to wait for the animation to complete
      await tester.pumpAndSettle();      
      expect(
        tester.widget<MaterialButton>(catalystButton).color,
        fallbackColor,
      );
      expect(
        tester.widget<MaterialButton>(catalystButton).color,
        fallbackColor,
      );
    });

    testWidgets('Catalyst Theme is applied after switch', (tester) async {
      await tester.pumpWidget(
        buildApp(),
      );

      final catalystButton = find.byKey(catalystKey);
      final fallbackButton = find.byKey(fallbackKey);

      expect(catalystButton, findsOneWidget);
      expect(fallbackButton, findsOneWidget);
      
      // We first switch do FallbackBrand, we wait for the animation completion
      // and then we switch back to the CatalystBrand to check the correct
      // color is applied.
      await tester.tap(fallbackButton);
      await tester.pumpAndSettle();
      await tester.tap(catalystButton);
      await tester.pumpAndSettle(); 
      expect(
        tester.widget<MaterialButton>(catalystButton).color,
        catalystColor,
      );
      expect(
        tester.widget<MaterialButton>(catalystButton).color,
        catalystColor,
      );
    });

  });

}
