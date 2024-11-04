import 'dart:typed_data';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:pinenacl/digests.dart';

/// The size of the script hash in bytes.
const scriptHashSize = 28;

/// Define an enum for the different types of native scripts
enum NativeScriptType {
  /// Public key
  pubkey(0),

  /// All
  all(1),

  /// Any
  any(2),

  /// N of K
  nOfK(3),

  /// Invalid before
  invalidBefore(4),

  /// Invalid after
  invalidAfter(5);

  /// The value of the enum
  final int value;

  const NativeScriptType(this.value);
}

/// Define an enum for the different types of reference scripts
enum RefScriptType {
  /// Native script
  native(0),

  /// PlutusV1 script
  plutusV1(1),

  /// PlutusV2 script
  plutusV2(2),

  /// PlutusV3 script
  plutusV3(3);

  /// The value of the enum
  final int value;

  const RefScriptType(this.value);
}

/// Define a sealed class for scripts that extends Equatable.
sealed class Script extends Equatable implements CborEncodable {
  const Script();

  /// Gets the tag for the script type.
  ///
  /// This tag helps identify different script types:
  /// - `0` for `NativeScript`
  /// - `1` for `PlutusV1Script`
  /// - `2` for `PlutusV2Script`
  /// - `3` for `PlutusV3Script`
  ///
  /// Throws an `ArgumentError` if the script type is not recognized.
  ///
  /// Returns:
  /// - An integer representing the script type tag.
  int get tag => switch (this) {
        NativeScript _ => 0,
        PlutusV1Script _ => 1,
        PlutusV2Script _ => 2,
        PlutusV3Script _ => 3,
        _ => throw ArgumentError.value(
            this,
            'script',
            'Invalid script type to hash.',
          ),
      };

  /// Computes the hash of the script.
  ///
  /// This method converts the script to its CBOR representation,
  /// adds a tag based on the script type, and then computes the
  /// Blake2b hash of the resulting bytes.
  Uint8List get hash {
    final cborValue = toCbor();
    final cborBytes = cbor.encode(cborValue);

    final bytes = Uint8List.fromList([tag, ...cborBytes]);
    return Hash.blake2b(bytes, digestSize: scriptHashSize);
  }

  static CborValue _handleDoubleEncodedCbor(CborValue cborValue) {
    if (cborValue is CborBytes) {
      try {
        return cbor.decode(cborValue.bytes);
      } catch (_) {}
    }
    return cborValue;
  }

  /// The length of the script in bytes.
  ///
  /// This is an abstract getter that must be implemented by the child classes.
  int get length;
}

/// Abstract base class for native scripts, extending [Script].
sealed class NativeScript extends Script {
  const NativeScript();

  /// Factory constructor to create a [NativeScript] from a CBOR value.
  /// The type of native script is determined by the first element in the CBOR
  /// list. If the first element is not a CborSmallInt, an exception is thrown.
  factory NativeScript.fromCbor(CborValue value) {
    if (value is CborList) {
      try {
        final type =
            NativeScriptType.values[(value[0] as CborSmallInt).toInt()];
        return switch (type) {
          NativeScriptType.pubkey => ScriptPubkey.fromCbor(value),
          NativeScriptType.all => ScriptAll.fromCbor(value),
          NativeScriptType.any => ScriptAny.fromCbor(value),
          NativeScriptType.nOfK => ScriptNOfK.fromCbor(value),
          NativeScriptType.invalidBefore => InvalidBefore.fromCbor(value),
          NativeScriptType.invalidAfter => InvalidAfter.fromCbor(value),
        };
        // ignore: avoid_catching_errors
      } on RangeError catch (e) {
        throw ArgumentError.value(
          value,
          'type',
          'Invalid NativeScript type value $e.',
        );
      }
    } else {
      throw ArgumentError.value(
        value,
        'value',
        'Expected proper NativeScript as CborList',
      );
    }
  }

  /// Creates a NativeScript instance from a JSON object.
  ///
  /// The JSON object should have a 'type' field that indicates the type of
  /// script to create. Depending on the script type, the JSON object may also
  /// contain other fields with additional data.
  ///
  /// Supported script types:
  /// - 'sig': Creates a ScriptPubkey instance. The JSON object should have a
  /// 'keyHash' field that contains the key hash to use in the [ScriptPubkey].
  /// - 'all': Creates a ScriptAll instance. The JSON object should have a
  /// 'scripts' field that contains a list of JSON objects representing the
  ///  scripts to include in the [ScriptAll].
  /// - 'any': Creates a ScriptAny instance. The JSON object should have a
  /// 'scripts' field that contains a list of JSON objects representing the
  /// scripts to include in the [ScriptAny].
  /// - 'atLeast': Creates a ScriptNOfK instance. The JSON object should have a
  /// 'required' field that contains the number of scripts that must be
  /// satisfied, and a 'scripts' field that contains a list of JSON objects
  /// representing the scripts to include in the [ScriptNOfK].
  /// - 'before': Creates an InvalidBefore instance. The JSON object should have
  /// a 'slot' field that contains the slot number to use in the
  /// [InvalidBefore].
  /// - 'after': Creates an InvalidAfter instance. The JSON object should have a
  /// 'slot' field that contains the slot number to use in the [InvalidAfter].
  ///
  /// If the JSON object contains an unsupported script type, an ArgumentError
  /// is thrown.
  static NativeScript fromJSON(Map<String, dynamic> json) {
    return switch (json['type']) {
      'sig' =>
        ScriptPubkey(Ed25519PublicKeyHash.fromHex(json['keyHash'] as String)),
      'all' => ScriptAll(
          (json['scripts'] as List<Map<String, dynamic>>)
              .map<NativeScript>(fromJSON)
              .toList(),
        ),
      'any' => ScriptAny(
          (json['scripts'] as List<Map<String, dynamic>>)
              .map<NativeScript>(fromJSON)
              .toList(),
        ),
      'atLeast' => ScriptNOfK(
          json['required'] as int,
          (json['scripts'] as List<Map<String, dynamic>>)
              .map<NativeScript>(fromJSON)
              .toList(),
        ),
      'before' => InvalidAfter(json['slot'] as int),
      'after' => InvalidBefore(json['slot'] as int),
      _ => throw ArgumentError('Unknown script type: ${json['type']}')
    };
  }

  static void _invalidCborError(CborValue value) =>
      throw ArgumentError.value(value, 'value', 'Invalid NativeScript cbor');

  /// Checks if a CBOR value is a valid generic native script.
  static void _checkGenericNativeScriptValidity(CborValue value) {
    if (value is! CborList || value.length != 2 || value[1] is! CborBytes) {
      _invalidCborError(value);
    }
  }

  /// Checks if a CBOR value is a valid list-based native script.
  static void _checkListNativeScriptValidity(CborValue value) {
    if (value is! CborList || value.length != 2 || value[1] is! CborList) {
      _invalidCborError(value);
    }
  }

  /// Checks if a CBOR value is a valid bounded native script.
  static void _checkBoundedNativeScriptValidity(CborValue value) {
    if (value is! CborList || value.length != 2 || value[1] is! CborSmallInt) {
      _invalidCborError(value);
    }
  }

  /// Returns the length of the [NativeScript]'s in bytes.
  @override
  int get length => cbor.encode(toCbor()).length;
}

/// Class representing a public key based native script.
class ScriptPubkey extends NativeScript {
  /// Public key hash.
  final Ed25519PublicKeyHash addrKeyHash;

  /// Constructor for the [ScriptPubkey] class.
  const ScriptPubkey(this.addrKeyHash);

  /// Factory constructor to create a [ScriptPubkey] from a CBOR list.
  factory ScriptPubkey.fromCbor(CborList value) {
    NativeScript._checkGenericNativeScriptValidity(value);

    return ScriptPubkey(Ed25519PublicKeyHash.fromCbor(value[1]));
  }

  /// Converts the [ScriptPubkey] to its CBOR format.
  @override
  CborValue toCbor() => CborList(
        [
          CborSmallInt(NativeScriptType.pubkey.value),
          CborBytes(addrKeyHash.bytes),
        ],
      );

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [addrKeyHash];
}

/// Class representing an "all" native script (AND operation).
class ScriptAll extends NativeScript {
  /// List of the required signatures.
  final List<NativeScript> nativeScripts;

  /// Constructor for the [ScriptAll] class.
  const ScriptAll(this.nativeScripts);

  /// Factory constructor to create a [ScriptAll] from a CBOR list.
  factory ScriptAll.fromCbor(CborList value) {
    NativeScript._checkListNativeScriptValidity(value);
    final scripts = (value[1] as CborList)
        .map((e) => NativeScript.fromCbor(e as CborList))
        .toList();
    return ScriptAll(scripts);
  }

  /// Converts the [ScriptAll] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.all.value),
        CborList(nativeScripts.map((s) => s.toCbor()).toList()),
      ]);

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [nativeScripts];
}

/// Class representing an "any" native script (OR operation).
class ScriptAny extends NativeScript {
  /// List of the available signatures.
  final List<NativeScript> nativeScripts;

  /// Constructor for the [ScriptAny] class.
  const ScriptAny(this.nativeScripts);

  /// Factory constructor to create a [ScriptAny] from a CBOR value.
  factory ScriptAny.fromCbor(CborValue value) {
    NativeScript._checkListNativeScriptValidity(value);
    final scripts = ((value as CborList)[1] as CborList)
        .map((e) => NativeScript.fromCbor(e as CborList))
        .toList();
    return ScriptAny(scripts);
  }

  /// Converts the [ScriptAny] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.any.value),
        CborList(nativeScripts.map((s) => s.toCbor()).toList()),
      ]);

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [nativeScripts];
}

/// Class representing an "n of k" native script (M of N operation).
class ScriptNOfK extends NativeScript {
  /// The number of required signatures.
  final int n;

  /// The list of native scripts.
  final List<NativeScript> nativeScripts;

  /// Creates a new [ScriptNOfK] with the given [n] and [nativeScripts].
  const ScriptNOfK(this.n, this.nativeScripts);

  /// Factory constructor to create a [ScriptNOfK] from a CBOR value.
  factory ScriptNOfK.fromCbor(CborValue value) {
    if (value is! CborList ||
        value.length != 3 ||
        value[1] is! CborSmallInt ||
        value[2] is! CborList) {
      throw ArgumentError.value(value, 'value', 'Invalid ScriptNOfK');
    }
    final n = (value[1] as CborSmallInt).value;
    final scripts = (value[2] as CborList)
        .map((e) => NativeScript.fromCbor(e as CborList))
        .toList();
    return ScriptNOfK(n, scripts);
  }

  /// Converts the [ScriptNOfK] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.nOfK.value),
        CborSmallInt(n),
        CborList(nativeScripts.map((s) => s.toCbor()).toList()),
      ]);

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [n, nativeScripts];
}

/// Class representing an "invalid before" native script (time-locked).
class InvalidBefore extends NativeScript {
  /// Converts the [InvalidBefore] to its CBOR format.
  final int timestamp;

  /// Factory constructor to create an [InvalidBefore] from a CBOR list.
  const InvalidBefore(this.timestamp);

  /// Factory constructor to create an [InvalidBefore] from a CBOR list.
  factory InvalidBefore.fromCbor(CborList value) {
    NativeScript._checkBoundedNativeScriptValidity(value);
    return InvalidBefore((value[1] as CborSmallInt).value);
  }

  /// Converts the [InvalidBefore] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.invalidBefore.value),
        CborSmallInt(timestamp),
      ]);

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [timestamp];
}

/// Class representing an "invalid after" native script (time-locked).
class InvalidAfter extends NativeScript {
  /// Converts the [InvalidAfter] to its CBOR format.
  final int timestamp;

  /// Factory constructor to create an [InvalidAfter] from a CBOR list.
  const InvalidAfter(this.timestamp);

  /// Factory constructor to create an [InvalidAfter] from a CBOR list.
  factory InvalidAfter.fromCbor(CborList value) {
    NativeScript._checkBoundedNativeScriptValidity(value);
    return InvalidAfter((value[1] as CborSmallInt).value);
  }

  /// Converts the [InvalidAfter] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.invalidAfter.value),
        CborSmallInt(timestamp),
      ]);

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [timestamp];
}

/// Abstract base class for Plutus scripts, extending [Script].
sealed class PlutusScript extends Script {
  /// [PlutusScript] represented as encoded CBOR bytes.
  final List<int> bytes;

  // TODO(ilap): Check whether the Plutus script bytes are valid CBOR CborByte-s
  // and throw an error if does not.
  /// [PlutusScript] constructor.
  const PlutusScript(this.bytes);

  /// Converts the [PlutusScript] to its CBOR format.
  /// All Plutus scripts are serialized CBOR bytes.
  @override
  CborValue toCbor() => CborBytes(bytes);

  /// Validates if the CBOR value is a valid Plutus script.
  static CborValue _plutusScriptValidity(CborValue value) {
    return value is CborBytes
        ? Script._handleDoubleEncodedCbor(value)
        : throw ArgumentError.value(
            value,
            'value',
            'Invalid Plutus script cbor',
          );
  }

  /// Equatable props for value comparison of all Plutus scripts.
  @override
  List<Object?> get props => [bytes];

  /// Returns the length of the [PlutusScript]'s in bytes.
  @override
  int get length => cbor.encode(CborBytes(bytes)).length;
}

/// Class representing a Plutus V1 script.
class PlutusV1Script extends PlutusScript {
  /// [PlutusV1Script] constructor.
  const PlutusV1Script._(super.bytes);

  /// Factory constructor to create an [PlutusV1Script] from a CBOR list.
  factory PlutusV1Script.fromCbor(CborValue value) {
    final validCbor = PlutusScript._plutusScriptValidity(value);
    return PlutusV1Script._((validCbor as CborBytes).bytes);
  }

  /// Factory constructor to create an [PlutusV2Script] from a CBOR hex string.
  factory PlutusV1Script.fromHex(String cborHex) {
    final cborValue = cbor.decode(hex.decode(cborHex));
    return PlutusV1Script.fromCbor(cborValue);
  }
}

/// Class representing a Plutus V2 script.
class PlutusV2Script extends PlutusScript {
  /// [PlutusV2Script] constructor.
  const PlutusV2Script._(super.bytes);

  /// Factory constructor to create an [PlutusV2Script] from a CBOR list.
  factory PlutusV2Script.fromCbor(CborValue cborValue) {
    final validCbor = PlutusScript._plutusScriptValidity(cborValue);
    return PlutusV2Script._((validCbor as CborBytes).bytes);
  }

  /// Factory constructor to create an [PlutusV2Script] from a CBOR hex string.
  factory PlutusV2Script.fromHex(String cborHex) {
    final cborValue = cbor.decode(hex.decode(cborHex));
    return PlutusV2Script.fromCbor(cborValue);
  }
}

/// Class representing a Plutus V3 script.
class PlutusV3Script extends PlutusScript {
  /// [PlutusV3Script] constructor.
  const PlutusV3Script._(super.bytes);

  /// Factory constructor to create an [PlutusV3Script] from a CBOR list.
  factory PlutusV3Script.fromCbor(CborValue cborValue) {
    final validCbor = PlutusScript._plutusScriptValidity(cborValue);
    return PlutusV3Script._((validCbor as CborBytes).bytes);
  }

  /// Factory constructor to create an [PlutusV2Script] from a CBOR hex string.
  factory PlutusV3Script.fromHex(String cborHex) {
    final cborValue = cbor.decode(hex.decode(cborHex));
    return PlutusV3Script.fromCbor(cborValue);
  }
}

/// Class representing a reference script in an transaction output.
class ScriptRef extends Script {
  /// A reference script.
  final Script script;

  /// Creates a new [ScriptRef] with the given [script].
  const ScriptRef(this.script);

  /// Factory constructor to create a [ScriptRef] from a CBOR list.
  factory ScriptRef.fromCbor(CborValue value) {
    if (value is CborList) {
      final type = RefScriptType.values[(value[0] as CborSmallInt).toInt()];
      final script = switch (type) {
        RefScriptType.native => NativeScript.fromCbor(value[1]),
        RefScriptType.plutusV1 => PlutusV1Script.fromCbor(value[1]),
        RefScriptType.plutusV2 => PlutusV2Script.fromCbor(value[1]),
        RefScriptType.plutusV3 => PlutusV3Script.fromCbor(value[1]),
      };
      return ScriptRef(script);
    } else {
      throw ArgumentError.value(
        value,
        'value',
        'Expected ScriptRef as CborList',
      );
    }
  }

  @override
  CborValue toCbor() {
    final index = switch (script) {
      NativeScript _ => RefScriptType.native,
      PlutusV1Script _ => RefScriptType.plutusV1,
      PlutusV2Script _ => RefScriptType.plutusV2,
      PlutusV3Script _ => RefScriptType.plutusV3,
      _ => throw ArgumentError.value(
          script,
          'script',
          'Invalid script reference type',
        ),
    };
    return CborList([CborSmallInt(index.value), script.toCbor()]);
  }

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [script];

  /// Returns the length of the [ScriptRef]'s script in bytes.
  @override
  int get length => script.length;
}
