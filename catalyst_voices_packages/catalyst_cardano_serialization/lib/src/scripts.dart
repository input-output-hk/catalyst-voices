import 'dart:typed_data';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:pinenacl/digests.dart';

const scriptHashSize = 28;

// Define an enum for the different types of native scripts
enum NativeScriptType {
  pubkey(0),
  all(1),
  any(2),
  nOfK(3),
  invalidBefore(4),
  invalidAfter(5);

  final int value;
  const NativeScriptType(this.value);
}

// Define an enum for the different types of reference scripts
enum RefScriptType {
  native(0),
  plutusV1(1),
  plutusV2(2),
  plutusV3(3);

  final int value;
  const RefScriptType(this.value);
}

// Define a sealed class for scripts that extends Equatable.
sealed class Script extends Equatable implements CborEncodable {
  const Script();

  // Define an abstract method for converting a script to CBOR
  CborValue toCbor();

  /// Computes the hash of the script.
  ///
  /// This method converts the script to its CBOR representation,
  /// adds a tag based on the script type, and then computes the
  /// [Blake2b] hash of the resulting bytes.
  Uint8List get hash {
    final tag = switch (this) {
      NativeScript _ => 0,
      PlutusV1Script _ => 1,
      PlutusV2Script _ => 2,
      PlutusV3Script _ => 3,
      _ => throw ArgumentError.value(
          this, 'script', 'Invalid script type to hash.'),
    };

    // Handle double-decoded CBOR for Plutus scripts, which may contain nested
    // CBOR.
    final cborToDecode = this.toCbor();

    final cborValue = cborToDecode is CborBytes
        ? () {
              try {
                return cbor
                    .decode(cborToDecode.bytes); // Attempt to decode again
              } catch (_) {
                return null; // If decoding fails, use the original CBOR value
              }
            }() ??
            cborToDecode
        : cborToDecode;

    final cborBytes = cbor.encode(cborValue);

    final bytes = Uint8List.fromList([tag, ...cborBytes]);
    return Hash.blake2b(bytes, digestSize: scriptHashSize);
  }
}

/// Abstract base class for native scripts, extending [Script].
sealed class NativeScript extends Script {
  const NativeScript();

  /// Factory constructor to create a [NativeScript] from a CBOR value.
  /// The type of native script is determined by the first element in the CBOR list.
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
      } on RangeError catch (e) {
        throw ArgumentError.value(
            value, 'type', 'Invalid NativScript type value ${e}.');
      }
    } else {
      throw ArgumentError.value(
          value, 'value', 'Expected proper NativeScript as CborList');
    }
  }

  /// Creates a NativeScript instance from a JSON object.
  ///
  /// The JSON object should have a 'type' field that indicates the type of script
  /// to create. Depending on the script type, the JSON object may also contain other
  /// fields with additional data.
  ///
  /// Supported script types:
  /// - 'sig': Creates a ScriptPubkey instance. The JSON object should have a 'keyHash'
  ///   field that contains the key hash to use in the ScriptPubkey.
  /// - 'all': Creates a ScriptAll instance. The JSON object should have a 'scripts'
  ///   field that contains a list of JSON objects representing the scripts to include
  ///   in the ScriptAll.
  /// - 'any': Creates a ScriptAny instance. The JSON object should have a 'scripts'
  ///   field that contains a list of JSON objects representing the scripts to include
  ///   in the ScriptAny.
  /// - 'atLeast': Creates a ScriptNOfK instance. The JSON object should have a 'required'
  ///   field that contains the number of scripts that must be satisfied, and a 'scripts'
  ///   field that contains a list of JSON objects representing the scripts to include
  ///   in the ScriptNOfK.
  /// - 'before': Creates an InvalidBefore instance. The JSON object should have a 'slot'
  ///   field that contains the slot number to use in the InvalidBefore.
  /// - 'after': Creates an InvalidAfter instance. The JSON object should have a 'slot'
  ///   field that contains the slot number to use in the InvalidAfter.
  ///
  /// If the JSON object contains an unsupported script type, an ArgumentError is thrown.
  static NativeScript fromJSON(Map<String, dynamic> json) {
    return switch (json['type']) {
      'sig' => ScriptPubkey(Uint8List.fromList(hex.decode(json['keyHash']))),
      'all' => ScriptAll(
          (json['scripts'] as List)
              .map((scriptJson) => fromJSON(scriptJson))
              .toList(),
        ),
      'any' => ScriptAny(
          (json['scripts'] as List)
              .map((scriptJson) => fromJSON(scriptJson))
              .toList(),
        ),
      'atLeast' => ScriptNOfK(
          json['required'] as int,
          (json['scripts'] as List)
              .map((scriptJson) => fromJSON(scriptJson))
              .toList(),
        ),
      'before' => InvalidAfter(json['slot'] as int),
      'after' => InvalidBefore(json['slot'] as int),
      _ => throw ArgumentError('Unknown script type: ${json['type']}')
    };
  }

  static void _invalidCborError(value) =>
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
}

/// Class representing a publickey based native script.
class ScriptPubkey extends NativeScript {
  final Uint8List addrKeyhash;

  const ScriptPubkey(this.addrKeyhash);

  /// Converts the [ScriptPubkey] to its CBOR format.
  @override
  CborValue toCbor() => CborList(
      [CborSmallInt(NativeScriptType.pubkey.value), CborBytes(addrKeyhash)]);

  /// Factory constructor to create a [ScriptPubkey] from a CBOR list.
  factory ScriptPubkey.fromCbor(CborList value) {
    NativeScript._checkGenericNativeScriptValidity(value);
    return ScriptPubkey(Uint8List.fromList((value[1] as CborBytes).bytes));
  }

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [addrKeyhash];
}

/// Class representing an "all" native script (AND operation).
class ScriptAll extends NativeScript {
  final List<NativeScript> nativeScripts;

  const ScriptAll(this.nativeScripts);

  /// Converts the [ScriptAll] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.all.value),
        CborList(nativeScripts.map((s) => s.toCbor()).toList())
      ]);

  /// Factory constructor to create a [ScriptAll] from a CBOR list.
  factory ScriptAll.fromCbor(CborList value) {
    NativeScript._checkListNativeScriptValidity(value);
    final scripts = (value[1] as CborList)
        .map((e) => NativeScript.fromCbor(e as CborList))
        .toList();
    return ScriptAll(scripts);
  }

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [nativeScripts];
}

/// Class representing an "any" native script (OR operation).
class ScriptAny extends NativeScript {
  final List<NativeScript> nativeScripts;

  const ScriptAny(this.nativeScripts);

  /// Converts the [ScriptAny] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.any.value),
        CborList(nativeScripts.map((s) => s.toCbor()).toList())
      ]);

  /// Factory constructor to create a [ScriptAny] from a CBOR value.
  factory ScriptAny.fromCbor(CborValue value) {
    NativeScript._checkListNativeScriptValidity(value);
    final scripts = ((value as CborList)[1] as CborList)
        .map((e) => NativeScript.fromCbor(e as CborList))
        .toList();
    return ScriptAny(scripts);
  }

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [nativeScripts];
}

/// Class representing an "n of k" native script (M of N operation).
class ScriptNOfK extends NativeScript {
  final int n;
  final List<NativeScript> nativeScripts;

  const ScriptNOfK(this.n, this.nativeScripts);

  /// Converts the [ScriptNOfK] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.nOfK.value),
        CborSmallInt(n),
        CborList(nativeScripts.map((s) => s.toCbor()).toList())
      ]);

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

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [n, nativeScripts];
}

/// Class representing an "invalid before" native script (time-locked).
class InvalidBefore extends NativeScript {
  final int timestamp;

  const InvalidBefore(this.timestamp);

  /// Converts the [InvalidBefore] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.invalidBefore.value),
        CborSmallInt(timestamp)
      ]);

  /// Factory constructor to create an [InvalidBefore] from a CBOR list.
  factory InvalidBefore.fromCbor(CborList value) {
    NativeScript._checkBoundedNativeScriptValidity(value);
    return InvalidBefore((value[1] as CborSmallInt).value);
  }

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [timestamp];
}

/// Class representing an "invalid after" native script (time-locked).
class InvalidAfter extends NativeScript {
  final int timestamp;
  const InvalidAfter(this.timestamp);

  /// Converts the [InvalidAfter] to its CBOR format.
  @override
  CborValue toCbor() => CborList([
        CborSmallInt(NativeScriptType.invalidAfter.value),
        CborSmallInt(timestamp)
      ]);

  /// Factory constructor to create an [InvalidAfter] from a CBOR list.
  factory InvalidAfter.fromCbor(CborList value) {
    NativeScript._checkBoundedNativeScriptValidity(value);
    return InvalidAfter((value[1] as CborSmallInt).value);
  }

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [timestamp];
}

/// Abstract base class for Plutus scripts, extending [Script].
sealed class PlutusScript extends Script {
  final Uint8List bytes;

  // TODO: Check whether the Plutus script bytes are valid CBOR CborByte-s
  // and throw an error if does not.
  const PlutusScript(this.bytes);

  /// Converts the [PlutusScript] to its CBOR format.
  /// All Plutus scripts are serialized CBOR bytes.
  @override
  CborValue toCbor() => cbor.decode(bytes);

  /// Validates if the CBOR value is a valid Plutus script.
  static void _plutusScriptValidity(CborValue value) {
    if (value is! CborBytes) {
      throw ArgumentError.value(value, 'value', 'Invalid Plutus script cbor');
    }
  }

  /// Equatable props for value comparison of all Plutus scripts.
  @override
  List<Object?> get props => [bytes];
}

/// Class representing a Plutus V1 script.
class PlutusV1Script extends PlutusScript {
  const PlutusV1Script(Uint8List bytes) : super(bytes);

  factory PlutusV1Script.fromCbor(CborValue value) {
    PlutusScript._plutusScriptValidity(value);
    return PlutusV1Script(Uint8List.fromList((value as CborBytes).bytes));
  }
}

/// Class representing a Plutus V2 script.
class PlutusV2Script extends PlutusScript {
  const PlutusV2Script(Uint8List bytes) : super(bytes);

  factory PlutusV2Script.fromCbor(CborValue value) {
    PlutusScript._plutusScriptValidity(value);
    return PlutusV2Script(Uint8List.fromList((value as CborBytes).bytes));
  }
}

/// Class representing a Plutus V3 script.
class PlutusV3Script extends PlutusScript {
  const PlutusV3Script(Uint8List bytes) : super(bytes);

  factory PlutusV3Script.fromCbor(CborValue value) {
    PlutusScript._plutusScriptValidity(value);
    return PlutusV3Script(Uint8List.fromList((value as CborBytes).bytes));
  }
}

/// Class representing a reference script in an [TransactionOutput].
class ScriptRef extends Script {
  final Script script;

  const ScriptRef(this.script);

  /// Factory constructor to create a [RefScript] from a CBOR list.
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
          value, 'value', 'Expected ScriptRef as CborList');
    }
  }

  @override
  CborValue toCbor() {
    final index = switch (script) {
      NativeScript _ => RefScriptType.native,
      PlutusV1Script _ => RefScriptType.plutusV1,
      PlutusV2Script _ => RefScriptType.plutusV2,
      PlutusV3Script _ => RefScriptType.plutusV3,
      _ => throw 'Invalid script reference type',
    };
    return CborList([CborSmallInt(index.value), script.toCbor()]);
  }

  /// Equatable props for value comparison.
  @override
  List<Object?> get props => [script];
}

void main() {
  final script = ScriptPubkey(Uint8List.fromList([1, 2, 3, 4]));
  final cborValue = script.toCbor();
  print(cborValue);

  final decodedScript = NativeScript.fromCbor(cborValue as CborList);
  print(decodedScript);

  // Example: Creating and encoding a PlutusV1Script
  Uint8List plutusBytes = Uint8List.fromList([0x42, 0x01, 0x02]);
  PlutusV1Script plutusV1Script = PlutusV1Script(plutusBytes);
  final encodedPlutusV1 = plutusV1Script.toCbor();
  print("Encoded PlutusV1Script: $encodedPlutusV1");

  // Example: Decoding back to PlutusV1Script
  Script decodedScript1 = PlutusV1Script.fromCbor(encodedPlutusV1);
  print("Decoded Script: ${(decodedScript1 as PlutusV1Script).bytes}");

  // Example: Creating and encoding a ScriptAll with multiple native scripts
  ScriptAll scriptAll = ScriptAll([
    ScriptPubkey(Uint8List.fromList([1, 2, 3])),
    InvalidBefore(123456789),
  ]);
  final encodedScriptAll = scriptAll.toCbor();
  print("Encoded ScriptAll: $encodedScriptAll");

  // Example: Decoding back to ScriptAll
  NativeScript decodedNativeScript = NativeScript.fromCbor(encodedScriptAll);
  print("Decoded NativeScript: ${decodedNativeScript.runtimeType}");

  final scriptRef = CborList([CborSmallInt(0), encodedScriptAll]);
  final scriptRef0 = ScriptRef.fromCbor(scriptRef);
  final scriptRef1 = ScriptRef(scriptAll);

  print("All eq: ${scriptAll == NativeScript.fromCbor(encodedScriptAll)}");
  print("Encoded ScriptRef/1: ${scriptRef0 == scriptRef1}");

  final decodedScriptRef = ScriptRef.fromCbor(scriptRef);
  print("Decoded Script: $decodedScriptRef");
  print("IS Native? Script   : ${decodedScriptRef.runtimeType}");
  print("IsNative? ${decodedScriptRef is NativeScript}");
  print("isAll? ${decodedScriptRef is ScriptAll}");
  //final decodedScriptAll = ScriptRef.fromCbor(encodedScriptAll);

  /*
    Set tests: scripts should be value types

  */
  final nSet = Set<NativeScript>();
  final p1Set = Set<PlutusV1Script>();
  final p2Set = Set<PlutusV2Script>();
  final p3Set = Set<PlutusV3Script>();

  nSet.add(NativeScript.fromCbor(encodedScriptAll));
  nSet.add(NativeScript.fromCbor(encodedScriptAll));
  print("nSet:  ${nSet.length == 1}");

  p1Set.add(PlutusV1Script(plutusBytes));
  p1Set.add(PlutusV1Script(plutusBytes));
  print("p1Set: ${p1Set.length == 1}");

  p2Set.add(PlutusV2Script(plutusBytes));
  p2Set.add(PlutusV2Script(plutusBytes));
  print("p2Set: ${p2Set.length == 1}");

  p3Set.add(PlutusV3Script(plutusBytes));
  p3Set.add(PlutusV3Script(plutusBytes));
  print("p3Set: ${p3Set.length == 1}");

  // Example: Creating and encoding a ScriptRef with a PlutusV1Script
  final compiledCode = "4401020304";
  // XXXX "589101000032323232323232232253330054a22930a9980324811856616c696461746f722072657475726e65642066616c736500136565333333008001153330033370e900018029baa00115333007300637540022930a998020010b0a998020010b0a998020010b0a998020010b0a998020010b0a998020010b2481085f723a20566f6964005734ae7155ceaab9e5573eae91";
  /// final hash = "12b96851f48bac3b2758f3e221208d584d043ec4e6715a9955d5209d";
  final hash = "2e02f6baf97d236e0ec15280989048af22de7b72a9119a594103f0b2";
  final plutusBytes1 = hex.decode(compiledCode);
  final plutusV2Script1 = PlutusV2Script(Uint8List.fromList(plutusBytes1));
  final e = plutusV2Script1.hash;
  print("e: ${hex.encode(e)}");

  print("@@: ${hex.encode(Hash.blake2b(Uint8List.fromList([
            02,
            ...plutusBytes1
          ]), digestSize: 28))}");

  final bytes =
      hex.decode("e09d36c79dec9bd1b3d9e152247701cd0bb860b5ebfd1de8abb6735a");
  final expected = "208bdcaf2d83ae026964e23659c703a377473168a39cbdc2b0241115";
  final ns = ScriptPubkey(Uint8List.fromList(bytes));
  print("ns: $ns");
  print("ns: ${hex.encode(ns.hash)}");
  print("ns: ${hex.encode(ns.hash) == expected}");

  final n1 = ScriptPubkey(Uint8List.fromList(
      hex.decode("2f3d4cf10d0471a1db9f2d2907de867968c27bca6272f062cd1c2413")));
  final n2 = ScriptPubkey(Uint8List.fromList(
      hex.decode("f856c0c5839bab22673747d53f1ae9eed84afafb085f086e8e988614")));
  final n3 = ScriptPubkey(Uint8List.fromList(
      hex.decode("b275b08c999097247f7c17e77007c7010cd19f20cc086ad99d398538")));
  final any = ScriptNOfK(2, [n1, n2, n3]);

  const expexted = "1e3e60975af4971f7cc02ed4d90c87abaafd2dd070a42eafa6f5e939";
  print("any: $any");
  print("any: ${hex.encode(any.hash)}");
  print("any: ${hex.encode(any.hash) == expexted}");

  final nn1 = ScriptPubkey(Uint8List.fromList(
      hex.decode("b275b08c999097247f7c17e77007c7010cd19f20cc086ad99d398538")));
  final nn2 = InvalidAfter(3000);
  final nn3 = ScriptPubkey(Uint8List.fromList(
      hex.decode("966e394a544f242081e41d1965137b1bb412ac230d40ed5407821c37")));

  final all = ScriptAll([nn2, nn3]);

  final any1 = ScriptAny([nn1, all]);
  final any1h = any1.hash;
  const expexted1 = "6519f942518b8761f4b02e1403365b7d7befae1eb488b7fffcbab33f";
  print("any: $any1");
  print("any: ${hex.encode(any1h)}");
  print("any: ${hex.encode(any1h) == expexted1}");

  //final type = NativeScriptType.values[199];
  //print("type: $type");

  const json = {
    "type": "atLeast",
    "required": 2,
    "scripts": [
      {
        "type": "sig",
        "keyHash": "2f3d4cf10d0471a1db9f2d2907de867968c27bca6272f062cd1c2413"
      },
      {
        "type": "sig",
        "keyHash": "f856c0c5839bab22673747d53f1ae9eed84afafb085f086e8e988614"
      },
      {
        "type": "sig",
        "keyHash": "b275b08c999097247f7c17e77007c7010cd19f20cc086ad99d398538"
      },
    ]
  };
  final njs = NativeScript.fromJSON(json);
  print("njs: $njs");

  final doubleEncoded =
      PlutusV3Script(Uint8List.fromList([0x45, 0x44, 0x01, 0x02, 0x03, 0x04]));
  print("doubleEncoded: $doubleEncoded");
  print("doubleEncoded: ${hex.encode(doubleEncoded.hash)}");
  //print("doubleEncoded: ${doubleEncoded.toHex() == "e09d36c79dec9bd1b3d9e152247701cd0bb860b5ebfd1de8abb6735a"}");
}
