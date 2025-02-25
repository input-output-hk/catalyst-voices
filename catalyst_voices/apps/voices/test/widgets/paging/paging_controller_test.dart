import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagingController<String> controller;

  setUp(() {
    controller = PagingController(
      initialPage: 0,
      initialMaxResults: 100,
      itemsPerPage: 20,
    );
  });
  group(PagingController, () {
    test('initializes with correct values', () {
      expect(controller.currentPage, 0);
      expect(controller.maxResults, 100);
      expect(controller.itemsPerPage, 20);
      expect(controller.itemList, isEmpty);
      expect(controller.error, isNull);
    });

    test('nextPage increments currentPage', () {
      controller.nextPage();
      expect(controller.currentPage, 1);
    });

    test('prevPage decrements currentPage', () {
      controller
        ..nextPage()
        ..prevPage();
      expect(controller.currentPage, 0);
    });

    test('appendPage add items and updates currentPage', () {
      controller.appendPage(['a', 'b', 'c'], 1);
      expect(controller.itemList, ['a', 'b', 'c']);
      expect(controller.currentPage, 1);
    });

    test('page request listeners are notified', () {
      var capturedPageKey = 0;
      controller
        ..addPageRequestListener((pageKey, _, __) {
          capturedPageKey = pageKey;
        })
        ..notifyPageRequestListeners(1);
      expect(capturedPageKey, 1);
      expect(controller.value.isLoading, true);
    });

    test('state changes are properly notified through ValueNotifier', () {
      var notifiedValue = controller.value;
      controller.addListener(() {
        notifiedValue = controller.value;
      });

      final newItems = ['item1'];
      controller.itemList = newItems;

      expect(notifiedValue.itemList, equals(newItems));
    });

    test('maxResults can be updated', () {
      controller.maxResults = 200;
      expect(controller.maxResults, 200);
    });

    test('nextPageValue returns correct value', () {
      expect(controller.nextPageValue, equals(controller.currentPage + 1));
    });

    test('removes listeners correctly', () {
      var callCount = 0;
      void listener(int pageKey, _, __) => callCount++;

      controller
        ..addPageRequestListener(listener)
        ..notifyPageRequestListeners(1);
      expect(callCount, 1);

      controller
        ..removePageRequestListener(listener)
        ..notifyPageRequestListeners(1);
      expect(callCount, 1);
    });
  });
}
