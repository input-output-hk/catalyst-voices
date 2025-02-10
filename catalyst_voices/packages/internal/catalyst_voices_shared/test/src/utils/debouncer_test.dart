import 'package:catalyst_voices_shared/src/utils/debouncer.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Debouncer, () {
    test('Executes immediately when delay is zero', () {
      var called = false;
      Debouncer(delay: Duration.zero).run(() => called = true);
      expect(called, isTrue);
    });

    test('Executes after delay', () {
      fakeAsync((async) {
        var called = false;

        Debouncer(delay: const Duration(milliseconds: 100))
            .run(() => called = true);

        expect(called, isFalse);

        async.elapse(const Duration(milliseconds: 150));
        expect(called, isTrue);
      });
    });

    test('Cancels previous call when run is called again', () {
      fakeAsync((async) {
        var called = false;

        Debouncer(delay: const Duration(milliseconds: 100))
          ..run(() => called = true)
          ..run(() => called = false);

        async.elapse(const Duration(milliseconds: 150));
        expect(called, isFalse);
      });
    });
  });
}
