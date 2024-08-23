import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColumnsRow', () {
    testWidgets(
      'basic layout',
      (tester) async {
        // Given
        final children = List.generate(
          6,
          (index) => Container(key: Key('child_$index')),
        );

        final widget = MaterialApp(
          home: ColumnsRow(
            columnsCount: 3,
            children: children,
          ),
        );

        // When
        await tester.pumpWidget(widget);

        // Then
        expect(find.byKey(const Key('child_0')), findsOneWidget);
        expect(find.byKey(const Key('child_3')), findsOneWidget);
        expect(find.byKey(const Key('child_5')), findsOneWidget);
      },
    );

    testWidgets(
      'renders correctly with default spacing',
      (tester) async {
        // Given
        final children = List<Widget>.generate(
          6,
          (index) => Text('Item $index'),
        );

        final widget = MaterialApp(
          home: ColumnsRow(
            columnsCount: 2,
            children: children,
          ),
        );

        // When
        await tester.pumpWidget(widget);

        // Then
        for (var i = 0; i < children.length; i++) {
          expect(find.text('Item $i'), findsOneWidget);
        }

        expect(find.byType(Column), findsNWidgets(2));
      },
    );

    testWidgets(
      'correctly arranges children in specified columns',
      (tester) async {
        // Given
        const mainAxisSpacing = 12.0;
        const crossAxisSpacing = 8.0;
        final children = List<Widget>.generate(
          8,
          (index) => Text('Item $index'),
        );

        final widget = MaterialApp(
          home: ColumnsRow(
            columnsCount: 3,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            children: children,
          ),
        );

        // When
        await tester.pumpWidget(widget);

        // Then
        for (var i = 0; i < children.length; i++) {
          expect(find.text('Item $i'), findsOneWidget);
        }

        // Check the structure of the Column widgets
        expect(find.byType(Column), findsNWidgets(3));

        final columnWidgets = find.byType(Column).evaluate().toList();
        expect(columnWidgets.length, 3);

        final firstColumnChildren = columnWidgets[0].widget as Column;
        final secondColumnChildren = columnWidgets[1].widget as Column;
        final thirdColumnChildren = columnWidgets[2].widget as Column;

        expect((firstColumnChildren.children.first as Text).data, 'Item 0');
        expect(
          (firstColumnChildren.children[1] as SizedBox).height,
          crossAxisSpacing,
        );
        expect((firstColumnChildren.children[2] as Text).data, 'Item 1');
        expect(
          (firstColumnChildren.children[3] as SizedBox).height,
          crossAxisSpacing,
        );
        expect((firstColumnChildren.children[4] as Text).data, 'Item 2');

        expect((secondColumnChildren.children.first as Text).data, 'Item 3');
        expect(
          (secondColumnChildren.children[1] as SizedBox).height,
          crossAxisSpacing,
        );
        expect((secondColumnChildren.children[2] as Text).data, 'Item 4');
        expect(
          (secondColumnChildren.children[3] as SizedBox).height,
          crossAxisSpacing,
        );
        expect((secondColumnChildren.children[4] as Text).data, 'Item 5');

        expect((thirdColumnChildren.children.first as Text).data, 'Item 6');
        expect(
          (thirdColumnChildren.children[1] as SizedBox).height,
          crossAxisSpacing,
        );
        expect((thirdColumnChildren.children[2] as Text).data, 'Item 7');
      },
    );
  });
}
