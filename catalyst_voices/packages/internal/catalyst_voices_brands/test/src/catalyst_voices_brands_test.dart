import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/src/brand/brand_bloc.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const catalystKey = Key('C');

  Widget buildApp() => BlocProvider(
        create: (context) => BrandBloc(),
        child: BlocBuilder<BrandBloc, BrandState>(
          builder: (context, state) {
            return MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: Row(
                    children: [
                      CatalystSvgPicture.asset(
                        Theme.of(context).brandAssets.brand.logo(context).path,
                      ),
                      MaterialButton(
                        key: catalystKey,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          context.read<BrandBloc>().add(
                                const BrandChangedEvent(Brand.catalyst),
                              );
                        },
                        child: const Text('Catalyst'),
                      ),
                    ],
                  ),
                ),
              ),
              theme: ThemeBuilder.buildTheme(
                brand: state.brand,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeBuilder.buildTheme(
                brand: state.brand,
                brightness: Brightness.dark,
              ),
            );
          },
        ),
      );

  group('Test brands', () {
    // Colors used in the Brand themes as primary. They are used for
    // the color of the widgets we are testing and they are the colors
    // we will check against to ensure correct rendering.
    const catalystColor = VoicesColors.lightPrimary;

    testWidgets('Default Catalyst theme is applied', (tester) async {
      await tester.pumpWidget(
        buildApp(),
      );

      final catalystButton = find.byKey(catalystKey);

      expect(catalystButton, findsOneWidget);
      expect(
        tester.widget<MaterialButton>(catalystButton).color,
        catalystColor,
      );
    });
  });
  group('Test brand_assets', () {
    final catalystLogo = CatalystSvgPicture.asset(
      VoicesAssets.images.catalystLogo.path,
    );
    testWidgets('Logo from Default theme is applied', (tester) async {
      await tester.pumpWidget(
        buildApp(),
      );

      final logo = find.byType(CatalystSvgPicture).first;

      expect(logo, findsOneWidget);
      expect(
        tester.widget<CatalystSvgPicture>(logo).bytesLoader,
        catalystLogo.bytesLoader,
      );
    });
  });
}
