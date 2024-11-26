import 'package:catalyst_voices/widgets/menu/voices_menu.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  final menu = [
    MenuItem(
      id: '1',
      label: 'Rename',
      icon: VoicesAssets.icons.pencil.buildIcon(),
    ),
    SubMenuItem(
      id: '2',
      label: 'Move Private Team',
      icon: VoicesAssets.icons.switchHorizontal.buildIcon(),
      children: const [
        MenuItem(
          id: '3',
          label: 'Team 1: The Vikings',
        ),
        MenuItem(
          id: '4',
          label: 'Team 2: Pure Hearts',
        ),
      ],
    ),
    MenuItem(
      id: '5',
      label: 'Move to public',
      icon: VoicesAssets.icons.switchHorizontal.buildIcon(),
      showDivider: true,
      isEnabled: false,
    ),
    MenuItem(
      id: '6',
      label: 'Delete',
      icon: VoicesAssets.icons.trash.buildIcon(),
    ),
  ];

  group(VoicesMenu, () {
    testWidgets('displays first level menu correctly', (tester) async {
      // Given
      final widget = VoicesMenu(
        menuItems: menu,
        child: const Text('sample menu'),
      );

      // When
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Text)));
      await tester.tap(find.text('sample menu'));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(SubmenuButton), findsExactly(2));
      expect(find.byType(MenuItemButton), findsExactly(3));
      expect(find.text('Rename'), findsOne);
    });

    testWidgets('displays nested menu correctly', (tester) async {
      // Given
      final widget = VoicesMenu(
        menuItems: menu,
        child: const Text('sample menu'),
      );

      // When
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Text)));
      await tester.tap(find.text('sample menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Move Private Team'));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(SubmenuButton), findsExactly(2));
      expect(find.byType(MenuItemButton), findsExactly(5));
      expect(find.text('Team 1: The Vikings'), findsOne);
    });
  });
}
