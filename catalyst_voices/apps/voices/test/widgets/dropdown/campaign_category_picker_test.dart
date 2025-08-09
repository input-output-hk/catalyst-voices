import 'package:catalyst_voices/widgets/dropdown/campaign_category_picker.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(CampaignCategoryPicker, () {
    final items = [
      const DropdownMenuViewModel(
        name: 'Item 1',
        value: ProposalsRefCategoryFilter(ref: SignedDocumentRef(id: 'value1')),
        isSelected: false,
      ),
      const DropdownMenuViewModel(
        name: 'Item 2',
        value: ProposalsRefCategoryFilter(ref: SignedDocumentRef(id: 'value2')),
        isSelected: true,
      ),
    ];

    testWidgets('$CampaignCategoryPicker renders correctly', (WidgetTester tester) async {
      SignedDocumentRef? selectedValue;

      await tester.pumpApp(
        Scaffold(
          body: CampaignCategoryPicker(
            items: items,
            onSelected: (value) {
              selectedValue = value.ref;
            },
            buttonBuilder: (
              context,
              onTapCallback, {
              required isMenuOpen,
            }) {
              return VoicesGestureDetector(
                onTap: onTapCallback,
                child: const Text('Dropdown'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Dropdown'), findsOneWidget);

      await tester.tap(find.text('Dropdown'));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();
      expect(selectedValue, equals(const SignedDocumentRef(id: 'value1')));
    });

    testWidgets('$CampaignCategoryPicker applies tile color', (WidgetTester tester) async {
      const voicesColors = VoicesColorScheme.optional();

      await tester.pumpApp(
        Scaffold(
          body: CampaignCategoryPicker(
            items: items,
            buttonBuilder: (
              context,
              onTapCallback, {
              required isMenuOpen,
            }) {
              return VoicesGestureDetector(
                onTap: onTapCallback,
                child: const Text('Dropdown'),
              );
            },
            onSelected: (value) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Dropdown'));
      await tester.pumpAndSettle();

      final listTile1Finder = find.ancestor(
        of: find.text('Item 1'),
        matching: find.byType(VoicesListTile),
      );
      final listTile1 = tester.widget<VoicesListTile>(listTile1Finder);
      expect(listTile1.tileColor, isNull);

      final listTile2Finder = find.ancestor(
        of: find.text('Item 2'),
        matching: find.byType(VoicesListTile),
      );
      final listTile2 = tester.widget<VoicesListTile>(listTile2Finder);
      expect(listTile2.tileColor, equals(voicesColors.onSurfacePrimary08));
    });
  });
}
