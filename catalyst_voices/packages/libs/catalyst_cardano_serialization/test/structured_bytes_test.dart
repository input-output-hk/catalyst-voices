import 'package:catalyst_cardano_serialization/src/structured_bytes.dart';
import 'package:test/test.dart';

void main() {
  group(StructuredBytes, () {
    late List<int> initialBytes;
    late Map<_ByteKey, CborValueByteRange> initialContext;
    late StructuredBytes<_ByteKey> structuredBytes;

    setUp(() {
      initialBytes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
      initialContext = {
        _ByteKey.header: const CborValueByteRange(start: 0, end: 2),
        _ByteKey.payload: const CborValueByteRange(start: 2, end: 7, dataSize: 3),
        _ByteKey.signature: const CborValueByteRange(start: 7, end: 10, dataSize: 3),
      };
      structuredBytes = StructuredBytes(
        List.of(initialBytes), // Pass a copy to allow mutation
        context: Map.of(initialContext), // Pass a copy
      );
    });

    test('getters return unmodifiable collections', () {
      expect(() => structuredBytes.bytes.add(100), throwsUnsupportedError);

      expect(
        () => structuredBytes.context[_ByteKey.header] = const CborValueByteRange(start: 0, end: 1),
        throwsUnsupportedError,
      );
    });

    group('patchData', () {
      test('successfully patches data when conditions are met', () {
        final newData = [10, 11, 12]; // Same length as original payload dataSize
        structuredBytes.patchData(_ByteKey.payload, newData);

        // Expected bytes: [0, 1, | 2, 3, 10, 11, 12, | 7, 8, 9]
        // Data starts at index 4 (start:2, end:7, dataSize:3 -> header is 2 bytes)
        final expectedBytes = [0, 1, 2, 3, 10, 11, 12, 7, 8, 9];
        expect(structuredBytes.bytes, equals(expectedBytes));
      });

      test('throws ArgumentError if key is not in context', () {
        expect(
          () => structuredBytes.patchData(_ByteKey.header, [99]),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Cannot patch _ByteKey.header because data start is unknown',
            ),
          ),
        );
      });

      test('throws ArgumentError if dataSize is different', () {
        final newData = [10, 11];
        expect(
          () => structuredBytes.patchData(_ByteKey.payload, newData),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Cannot patch _ByteKey.payload because data size is different',
            ),
          ),
        );
      });
    });

    group('replaceValue', () {
      test('replaces range with value of same size', () {
        final newValue = [10, 11]; // Same size as header range (end-start = 2)
        structuredBytes.replaceValue(_ByteKey.header, newValue);

        final expectedBytes = [10, 11, 2, 3, 4, 5, 6, 7, 8, 9];
        expect(structuredBytes.bytes, equals(expectedBytes));

        final updatedRange = structuredBytes.context[_ByteKey.header]!;
        expect(updatedRange.start, 0);
        expect(updatedRange.end, 2);
      });

      test('replaces range with value of different (larger) size', () {
        final newValue = [100, 101, 102];
        structuredBytes.replaceValue(_ByteKey.header, newValue);

        final expectedBytes = [100, 101, 102, 2, 3, 4, 5, 6, 7, 8, 9];
        expect(structuredBytes.bytes, equals(expectedBytes));
        expect(structuredBytes.bytes.length, 11);

        final updatedRange = structuredBytes.context[_ByteKey.header]!;
        expect(updatedRange.end, 3);
      });

      test('updates subsequent ranges correctly when length changes', () {
        // Arrange
        // initialContext:
        // - header:    start: 0, end: 2
        // - payload:   start: 2, end: 7 (length 5)
        // - signature: start: 7, end: 10

        // Act
        // Replace payload (length 5) with a new value of length 7
        final newValue = [10, 11, 12, 13, 14, 15, 16];
        const lengthDelta = 2;
        structuredBytes.replaceValue(_ByteKey.payload, newValue);

        // Assert
        // 1. The header range (before the change) should be unaffected.
        expect(
          structuredBytes.context[_ByteKey.header],
          initialContext[_ByteKey.header],
          reason: 'Header range should not change.',
        );

        // 2. The payload range should be updated to its new end.
        final payloadRange = structuredBytes.context[_ByteKey.payload]!;
        expect(payloadRange.start, 2);
        expect(payloadRange.end, 2 + newValue.length);

        // 3. The signature range (after the change) should be shifted.
        final originalSignatureRange = initialContext[_ByteKey.signature]!;
        final signatureRange = structuredBytes.context[_ByteKey.signature]!;
        expect(
          signatureRange.start,
          originalSignatureRange.start + lengthDelta,
          reason: 'Signature start should be shifted.',
        );
        expect(
          signatureRange.end,
          originalSignatureRange.end + lengthDelta,
          reason: 'Signature end should be shifted.',
        );

        // 4. The total byte list should be longer.
        expect(structuredBytes.bytes.length, initialBytes.length + lengthDelta);
      });
    });
  });

  group(CborValueByteRange, () {
    test('constructor assigns properties correctly', () {
      const range = CborValueByteRange(start: 0, end: 10, dataSize: 5);

      expect(range.start, 0);
      expect(range.end, 10);
      expect(range.dataSize, 5);
    });

    group('dataStart getter', () {
      test('should return null when dataSize is null', () {
        const range = CborValueByteRange(start: 0, end: 10);
        expect(range.dataStart, isNull);
      });

      test('should calculate correct dataStart when dataSize is provided', () {
        const range = CborValueByteRange(start: 5, end: 20, dataSize: 8);
        expect(range.dataStart, 12);
      });
    });

    test('copyWith creates a new instance with updated values', () {
      const original = CborValueByteRange(start: 0, end: 10, dataSize: 5);

      // Copy with no changes
      final sameCopy = original.copyWith();
      expect(sameCopy, original);

      // Copy with a new start
      final newStart = original.copyWith(start: 2);
      expect(newStart.start, 2);
      expect(newStart.end, 10);
      expect(newStart.dataSize, 5);

      // Copy with a new end
      final newEnd = original.copyWith(end: 12);
      expect(newEnd.start, 0);
      expect(newEnd.end, 12);

      // Copy with a new dataSize
      final newDataSize = original.copyWith(dataSize: 8);
      expect(newDataSize.dataSize, 8);
    });

    test('equality works correctly with Equatable', () {
      const range1 = CborValueByteRange(start: 0, end: 10, dataSize: 5);
      const range2 = CborValueByteRange(start: 0, end: 10, dataSize: 5);
      const range3 = CborValueByteRange(start: 1, end: 10, dataSize: 5);

      expect(range1, equals(range2));
      expect(range1, isNot(equals(range3)));
    });
  });
}

// An enum to use as a key in tests
enum _ByteKey { header, payload, signature }
