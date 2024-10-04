import 'package:catalyst_voices_shared/src/utils/date_time_ext.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeExt', () {
    test('isSameDateAs', () {
      final today = DateTimeExt.now();
      expect(today.isSameDateAs(today), isTrue);
      expect(today.isSameDateAs(today.plusDays(1)), isFalse);
      expect(today.isSameDateAs(today.minusDays(1)), isFalse);
    });

    test('plusDays', () {
      final dstEnd = DateTime(2022, 10, 30, 0, 0);
      final nextDay = DateTime(2022, 10, 31, 0, 0);

      expect(dstEnd.plusDays(1), equals(nextDay));
    });

    test('minusDays', () {
      final dstEnd = DateTime(2022, 10, 31, 0, 0);
      final previousDay = DateTime(2022, 10, 30, 0, 0);

      expect(dstEnd.minusDays(1), equals(previousDay));
    });
  });
}
