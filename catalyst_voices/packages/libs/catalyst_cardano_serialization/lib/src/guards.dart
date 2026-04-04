import 'dart:collection';

import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';

/// Defines the [Guards] interface and its associated serialization logic.
abstract interface class Guards {
  /// Deserializes a [Guards] from CBOR.
  ///
  /// Dispatches based on the CBOR structure:
  /// ```cddl
  /// nonempty_set<addr_keyhash>     ; CborBytes → Ed25519PublicKeyHash (legacy)
  /// nonempty_oset<credential>
  ///   [0, addr_keyhash]            ; CborList → Ed25519PublicKeyHash
  ///   [1, script_hash]             ; CborList → Script
  /// ```
  static Set<Credential> fromCbor(CborValue? value) {
    if (value == null) return const {};

    final list = (value is CborTag ? value : value) as CborList;
    if (list.isEmpty) return const {};

    final first = list.first;

    // Legacy: nonempty_set<addr_keyhash>
    if (first is CborBytes) {
      return list.map((e) => Ed25519PublicKeyHash.fromCbor(e) as Credential).toSet();
    }

    // Conway: nonempty_oset<credential>
    if (first is CborList) {
      final set = SplayTreeSet<Credential>();

      for (final e in list) {
        final item = e as CborList;

        if (item.length != 2) {
          throw const FormatException('Invalid credential length');
        }

        final tag = (item[0] as CborSmallInt).value;
        final data = item[1];

        switch (tag) {
          case 0:
            set.add(Ed25519PublicKeyHash.fromCbor(data) as Credential);
            break;
          case 1:
            set.add(ScriptHash.fromCbor(data) as Credential);
            break;
          default:
            throw FormatException('Unknown credential tag: $tag');
        }
      }

      return set;
    }

    throw const FormatException('Invalid guards encoding');
  }

  /// Serializes a set of [Credential]s to CBOR.
  ///
  /// Emits the correct form based on the runtime type of the set and elements:
  /// ```cddl
  /// Set<Credential>          → nonempty_set<addr_keyhash>  (legacy)
  /// SplayTreeSet<Ed25519PublicKeyHash> → nonempty_oset [0, addr_keyhash]
  /// SplayTreeSet<Script>               → nonempty_oset [1, script_hash]
  /// ```
  static CborValue? guardsToCbor(Set<Credential>? guards) {
    if (guards == null) return null;

    final isOrdered = guards is SplayTreeSet;

    return CborList([
      for (final guard in guards)
        switch ((isOrdered, guard)) {
          (false, final Ed25519PublicKeyHash h) => h.toCbor(),
          (true, final Ed25519PublicKeyHash h) => CborList([const CborSmallInt(0), h.toCbor()]),
          (true, final ScriptHash s) => CborList([const CborSmallInt(1), s.toCbor()]),
          _ => throw FormatException('Unrecognised guard type: ${guard.runtimeType}'),
        },
    ]);
  }
}
