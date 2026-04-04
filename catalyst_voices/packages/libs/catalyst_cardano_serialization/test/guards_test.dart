import 'dart:collection';
import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/src/guards.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

void main() {
  // 28 zero bytes — valid addr_keyhash / script_hash length.
  final bytes28a = Uint8List(28);
  final bytes28b = Uint8List(28)..fillRange(0, 28, 0x01);
  final bytes28c = Uint8List(28)..fillRange(0, 28, 0x02);

  Ed25519PublicKeyHash keyHash(Uint8List b) => Ed25519PublicKeyHash.fromBytes(bytes: b);

  ScriptHash scriptHash(Uint8List b) => ScriptHash.fromBytes(bytes: b);

  group('Guards.fromCbor', () {
    test('returns empty set for null', () {
      expect(Guards.fromCbor(null), isEmpty);
    });

    test('returns empty set for empty CborList', () {
      expect(Guards.fromCbor(CborList([])), isEmpty);
    });

    // Legacy: nonempty_set<addr_keyhash>
    group('legacy nonempty_set<addr_keyhash>', () {
      test('single keyhash returns Set<Ed25519PublicKeyHash>', () {
        final cbor = CborList([CborBytes(bytes28a)]);
        final result = Guards.fromCbor(cbor);

        expect(result, isA<Set<Credential>>());
        expect(result, isNot(isA<SplayTreeSet<Credential>>()));
        expect(result.length, 1);
        expect(result.first, isA<Ed25519PublicKeyHash>());
      });

      test('multiple keyhashes are all deserialized', () {
        final cbor = CborList([
          CborBytes(bytes28a),
          CborBytes(bytes28b),
          CborBytes(bytes28c),
        ]);
        final result = Guards.fromCbor(cbor);

        expect(result.length, 3);
        expect(result.every((e) => e is Ed25519PublicKeyHash), isTrue);
      });

      test('duplicate keyhashes are deduplicated', () {
        final cbor = CborList([
          CborBytes(bytes28a),
          CborBytes(bytes28a),
        ]);
        final result = Guards.fromCbor(cbor);

        expect(result.length, 1);
      });
    });

    // Conway: nonempty_oset<credential> [0, addr_keyhash]
    group('Conway nonempty_oset [0, addr_keyhash]', () {
      test('single key credential returns SplayTreeSet', () {
        final cbor = CborList([
          CborList([const CborSmallInt(0), CborBytes(bytes28a)]),
        ]);
        final result = Guards.fromCbor(cbor);

        expect(result, isA<SplayTreeSet<Credential>>());
        expect(result.length, 1);
        expect(result.first, isA<Ed25519PublicKeyHash>());
      });

      test('multiple key credentials are all deserialized', () {
        final cbor = CborList([
          CborList([const CborSmallInt(0), CborBytes(bytes28a)]),
          CborList([const CborSmallInt(0), CborBytes(bytes28b)]),
        ]);
        final result = Guards.fromCbor(cbor);

        expect(result, isA<SplayTreeSet<Credential>>());
        expect(result.length, 2);
        expect(result.every((e) => e is Ed25519PublicKeyHash), isTrue);
      });

      test('duplicate key credentials are deduplicated', () {
        final cbor = CborList([
          CborList([const CborSmallInt(0), CborBytes(bytes28a)]),
          CborList([const CborSmallInt(0), CborBytes(bytes28a)]),
        ]);
        final result = Guards.fromCbor(cbor);

        expect(result.length, 1);
      });
    });

    // Conway: nonempty_oset<credential> [1, script_hash]
    group('Conway nonempty_oset [1, script_hash]', () {
      test('single script credential returns SplayTreeSet', () {
        final cbor = CborList([
          CborList([const CborSmallInt(1), CborBytes(bytes28a)]),
        ]);
        final result = Guards.fromCbor(cbor);

        expect(result, isA<SplayTreeSet<Credential>>());
        expect(result.length, 1);
        expect(result.first, isA<ScriptHash>());
      });

      test('multiple script credentials are all deserialized', () {
        final cbor = CborList([
          CborList([const CborSmallInt(1), CborBytes(bytes28a)]),
          CborList([const CborSmallInt(1), CborBytes(bytes28b)]),
        ]);
        final result = Guards.fromCbor(cbor);

        expect(result, isA<SplayTreeSet<Credential>>());
        expect(result.length, 2);
        expect(result.every((e) => e is ScriptHash), isTrue);
      });
    });

    // Error cases
    group('error cases', () {
      test('throws FormatException for unknown credential tag', () {
        final cbor = CborList([
          CborList([const CborSmallInt(99), CborBytes(bytes28a)]),
        ]);
        expect(() => Guards.fromCbor(cbor), throwsFormatException);
      });

      test('throws FormatException for invalid credential length', () {
        final cbor = CborList([
          CborList([const CborSmallInt(0)]), // missing data
        ]);
        expect(() => Guards.fromCbor(cbor), throwsFormatException);
      });

      test('throws FormatException for unrecognised encoding', () {
        final cbor = CborList([const CborSmallInt(42)]);
        expect(() => Guards.fromCbor(cbor), throwsFormatException);
      });
    });
  });

  group('Guards.guardsToCbor', () {
    test('returns null for null input', () {
      expect(Guards.guardsToCbor(null), isNull);
    });

    // Legacy
    group('legacy Set<Ed25519PublicKeyHash>', () {
      test('single keyhash encodes as raw CborBytes', () {
        final guards = <Credential>{keyHash(bytes28a)};
        final cbor = Guards.guardsToCbor(guards)! as CborList;

        expect(cbor.length, 1);
        expect(cbor.first, isA<CborBytes>());
      });

      test('multiple keyhashes encode as raw CborBytes list', () {
        final guards = <Credential>{
          keyHash(bytes28a),
          keyHash(bytes28b),
        };
        final cbor = Guards.guardsToCbor(guards)! as CborList;

        expect(cbor.length, 2);
        expect(cbor.every((e) => e is CborBytes), isTrue);
      });
    });

    // Conway key credential
    group('Conway SplayTreeSet<Ed25519PublicKeyHash>', () {
      test('encodes as [0, bytes] pairs', () {
        final guards = SplayTreeSet<Credential>()..add(keyHash(bytes28a));
        final cbor = Guards.guardsToCbor(guards)! as CborList;

        expect(cbor.length, 1);
        final pair = cbor.first as CborList;
        expect((pair[0] as CborSmallInt).value, 0);
        expect(pair[1], isA<CborBytes>());
      });

      test('multiple key credentials encode as [0, bytes] pairs', () {
        final guards = SplayTreeSet<Credential>()
          ..add(keyHash(bytes28a))
          ..add(keyHash(bytes28b));
        final cbor = Guards.guardsToCbor(guards)! as CborList;

        expect(cbor.length, 2);
        for (final item in cbor) {
          final pair = item as CborList;
          expect((pair[0] as CborSmallInt).value, 0);
        }
      });
    });

    // Conway script credential
    group('Conway SplayTreeSet<ScriptHash>', () {
      test('encodes as [1, bytes] pairs', () {
        final guards = SplayTreeSet<Credential>()..add(scriptHash(bytes28a));
        final cbor = Guards.guardsToCbor(guards)! as CborList;

        expect(cbor.length, 1);
        final pair = cbor.first as CborList;
        expect((pair[0] as CborSmallInt).value, 1);
        expect(pair[1], isA<CborBytes>());
      });
    });

    test('throws FormatException for unrecognised ordered guard type', () {
      // A SplayTreeSet containing a type that is neither
      // Ed25519PublicKeyHash nor ScriptHash should throw.
      final guards = SplayTreeSet<Credential>()..add(_UnknownCredential(''));
      expect(() => Guards.guardsToCbor(guards), throwsFormatException);
    });
  });

  group('Guards round-trip', () {
    test('legacy Set<Ed25519PublicKeyHash> round-trips correctly', () {
      final original = <Credential>{
        keyHash(bytes28a),
        keyHash(bytes28b),
      };
      final cbor = Guards.guardsToCbor(original)!;
      final restored = Guards.fromCbor(cbor);

      expect(original, equals(restored));
      expect(restored, isNot(isA<SplayTreeSet<Credential>>()));
      expect(restored.length, original.length);
      expect(restored.every((e) => e is Ed25519PublicKeyHash), isTrue);
    });

    test('Conway SplayTreeSet<Ed25519PublicKeyHash> round-trips correctly', () {
      final original = SplayTreeSet<Credential>()
        ..add(keyHash(bytes28a))
        ..add(keyHash(bytes28b));
      final cbor = Guards.guardsToCbor(original)!;
      final restored = Guards.fromCbor(cbor);

      expect(original, equals(restored));
      expect(restored, isA<SplayTreeSet<Credential>>());
      expect(restored.length, original.length);
      expect(restored.every((e) => e is Ed25519PublicKeyHash), isTrue);
    });

    test('Conway SplayTreeSet<ScriptHash> round-trips correctly', () {
      final original = SplayTreeSet<Credential>()
        ..add(scriptHash(bytes28a))
        ..add(scriptHash(bytes28b));
      final cbor = Guards.guardsToCbor(original)!;
      final restored = Guards.fromCbor(cbor);

      expect(original, equals(restored));
      expect(restored, isA<SplayTreeSet<Credential>>());
      expect(restored.length, original.length);
      expect(restored.every((e) => e is ScriptHash), isTrue);
    });
  });

  group('SplayTreeSet lexicographic ordering', () {
    // Bytes in ascending order: 0x00 < 0x01 < 0x02
    test('key credentials are ordered lexicographically by bytes', () {
      final guards = SplayTreeSet<Credential>()
        ..add(keyHash(bytes28c)) // 0x02...
        ..add(keyHash(bytes28a)) // 0x00...
        ..add(keyHash(bytes28b)); // 0x01...

      final ordered = guards.toList();
      expect(ordered[0], equals(keyHash(bytes28a))); // 0x00 first
      expect(ordered[1], equals(keyHash(bytes28b))); // 0x01 second
      expect(ordered[2], equals(keyHash(bytes28c))); // 0x02 third
    });

    test('script credentials are ordered lexicographically by bytes', () {
      final guards = SplayTreeSet<Credential>()
        ..add(scriptHash(bytes28c)) // 0x02...
        ..add(scriptHash(bytes28a)) // 0x00...
        ..add(scriptHash(bytes28b)); // 0x01...

      final ordered = guards.toList();
      expect(ordered[0], equals(scriptHash(bytes28a))); // 0x00 first
      expect(ordered[1], equals(scriptHash(bytes28b))); // 0x01 second
      expect(ordered[2], equals(scriptHash(bytes28c))); // 0x02 third
    });

    test('ordering is stable regardless of insertion order', () {
      final forwardInsert = SplayTreeSet<Credential>()
        ..add(keyHash(bytes28a))
        ..add(keyHash(bytes28b))
        ..add(keyHash(bytes28c));

      final reverseInsert = SplayTreeSet<Credential>()
        ..add(keyHash(bytes28c))
        ..add(keyHash(bytes28b))
        ..add(keyHash(bytes28a));

      expect(forwardInsert.toList(), equals(reverseInsert.toList()));
    });

    test('first byte difference determines order', () {
      final lo = Uint8List(28)..[0] = 0x00;
      final hi = Uint8List(28)..[0] = 0xFF;

      final guards = SplayTreeSet<Credential>()
        ..add(keyHash(hi))
        ..add(keyHash(lo));

      expect(guards.first, equals(keyHash(lo)));
      expect(guards.last, equals(keyHash(hi)));
    });

    test('equal prefix — later byte difference determines order', () {
      final a = Uint8List(28)..[27] = 0x00; // last byte 0x00
      final b = Uint8List(28)..[27] = 0x01; // last byte 0x01

      final guards = SplayTreeSet<Credential>()
        ..add(keyHash(b))
        ..add(keyHash(a));

      expect(guards.first, equals(keyHash(a)));
      expect(guards.last, equals(keyHash(b)));
    });

    test('CBOR encoding preserves lexicographic order', () {
      final guards = SplayTreeSet<Credential>()
        ..add(keyHash(bytes28c))
        ..add(keyHash(bytes28a))
        ..add(keyHash(bytes28b));

      final cbor = Guards.guardsToCbor(guards)! as CborList;

      // Encoded list should be in lexicographic order.
      final encodedBytes = cbor.map((e) => ((e as CborList)[1] as CborBytes).bytes).toList();

      expect(encodedBytes[0], equals(bytes28a));
      expect(encodedBytes[1], equals(bytes28b));
      expect(encodedBytes[2], equals(bytes28c));
    });

    test('round-trip preserves lexicographic order', () {
      final original = SplayTreeSet<Credential>()
        ..add(keyHash(bytes28c))
        ..add(keyHash(bytes28a))
        ..add(keyHash(bytes28b));

      final restored = Guards.fromCbor(Guards.guardsToCbor(original));
      expect(restored.toList(), equals(original.toList()));
    });
  });
}

/// A dummy [Credential] used to test the unrecognised guard type error path.
final class _UnknownCredential extends BaseHash implements Credential {
  /// Length of the [TransactionHash].
  static const int hashLength = 28;

  /// Constructs a generic [ScriptHash] from a hex string.
  _UnknownCredential(super.string) : super.fromHex();

  @override
  int get length => bytes.isEmpty ? 0 : hashLength;

  @override
  BaseHash get hash => this;
}
