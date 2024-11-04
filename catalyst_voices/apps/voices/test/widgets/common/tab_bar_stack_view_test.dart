import 'package:catalyst_voices/widgets/common/tab_bar_stack_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(TabBarStackView, () {
    testWidgets(
      'DefaultTabController is used when controller not specified explicitly',
      (tester) async {
        // Given
        const widget = Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'one'),
                    Tab(text: 'two'),
                  ],
                ),
                TabBarStackView(
                  children: [
                    Text('One Body'),
                    Text('Two Body'),
                  ],
                ),
              ],
            ),
          ),
        );

        // When
        await tester.pumpApp(widget);
        await tester.pumpAndSettle();

        // Then
        expect(find.text('One Body'), findsOne);
        expect(find.text('Two Body'), findsNothing);

        await tester.tap(find.text('two'));
        await tester.pump();

        expect(find.text('One Body'), findsNothing);
        expect(find.text('Two Body'), findsOne);
      },
    );

    testWidgets(
      'controller is used when specified explicitly',
      (tester) async {
        // Given
        const vsync = TestVSync();
        final controller = TabController(length: 2, vsync: vsync);
        addTearDown(controller.dispose);

        final widget = Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  controller: controller,
                  tabs: const [
                    Tab(text: 'one'),
                    Tab(text: 'two'),
                  ],
                ),
                TabBarStackView(
                  controller: controller,
                  children: const [
                    Text('One Body'),
                    Text('Two Body'),
                  ],
                ),
              ],
            ),
          ),
        );

        // When
        await tester.pumpApp(widget);
        await tester.pumpAndSettle();

        // Then
        expect(find.text('One Body'), findsOne);
        expect(find.text('Two Body'), findsNothing);

        controller.animateTo(1);
        await tester.pumpAndSettle();

        expect(find.text('One Body'), findsNothing);
        expect(find.text('Two Body'), findsOne);
      },
    );
  });
}
