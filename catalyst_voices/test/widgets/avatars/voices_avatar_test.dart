import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(VoicesAvatar, () {
    testWidgets('VoicesAvatar renders with default properties', (tester) async {
      // Create the widget by wrapping it in a MaterialApp for theme access.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VoicesAvatar(icon: Icon(Icons.person)),
          ),
        ),
      );

      // Verify if Container is rendered with the correct default radius.
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final containerWidget = tester.widget<Container>(containerFinder);
      expect(containerWidget.constraints?.maxWidth, 40);

      // Verify the icon is rendered.
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('VoicesAvatar applies custom radius and padding',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VoicesAvatar(
              icon: Icon(Icons.person),
              radius: 30,
              padding: EdgeInsets.all(16),
            ),
          ),
        ),
      );

      // Verify if Container is rendered with the correct custom radius.
      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      expect(containerWidget.constraints?.maxWidth, 60);

      // Verify the Padding is applied correctly.
      final paddingFinder = find.ancestor(
        of: find.byType(Icon),
        matching: find.byType(Padding),
      );
      final paddingWidget = tester.firstWidget<Padding>(paddingFinder);
      expect(paddingWidget.padding, const EdgeInsets.all(16));
    });

    testWidgets('VoicesAvatar uses custom foreground and background colors',
        (tester) async {
      const foregroundColor = Colors.red;
      const backgroundColor = Colors.green;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VoicesAvatar(
              icon: Icon(Icons.person),
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      );

      // Verify the background color is correctly applied.
      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      expect(
        (containerWidget.decoration! as BoxDecoration).color,
        backgroundColor,
      );

      // Verify the foreground color is correctly applied to the icon.
      final iconThemeFinder = find.ancestor(
        of: find.byType(Icon),
        matching: find.byType(IconTheme),
      );
      final iconThemeWidget = tester.firstWidget<IconTheme>(iconThemeFinder);

      expect(iconThemeWidget.data.color, foregroundColor);
    });

    testWidgets('VoicesAvatar calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoicesAvatar(
              icon: const Icon(Icons.person),
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the VoicesAvatar widget.
      await tester.tap(find.byType(VoicesAvatar));
      await tester.pump();

      // Verify the onTap callback is called.
      expect(tapped, true);
    });

    testWidgets('VoicesAvatar applies theme colors by default', (tester) async {
      final customTheme = ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          primaryContainer: Colors.blueGrey,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: customTheme,
          home: const Scaffold(
            body: VoicesAvatar(
              icon: Icon(Icons.person),
            ),
          ),
        ),
      );

      // Verify the background color is from the theme's primaryContainer.
      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      expect(
        (containerWidget.decoration! as BoxDecoration).color,
        Colors.blueGrey,
      );

      // Verify the foreground color is from the theme's primary.
      final iconThemeFinder = find.byType(IconTheme);
      final iconThemeWidget = tester.firstWidget<IconTheme>(iconThemeFinder);
      expect(iconThemeWidget.data.color, Colors.blue);
    });
  });
}
