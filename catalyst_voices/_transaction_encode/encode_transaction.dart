import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cbor/cbor.dart' as cbor;
import 'package:cbor/src/encoder/sink.dart' as cbor_internal;
import 'package:pinenacl/digests.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:typed_data/typed_buffers.dart';
import 'package:cbor/src/utils/arg.dart';

const int _txInputsHashSize = 16;
const int _validationSigSize = 64;
const int _metadataHashSize = 32;
const int _signingKeySize = 32;
const int _txInputHashSize = 32;
const int _txOutputAddressSize = 28;
const int _witnessSize = 64;
const int _purposeSize = 16;

const int _kPurpose                  = 0;
const int _kTxInputsHashPlaceholder  = 1;
const int _kValidationSignature      = 99;
const int _kFee                      = 2;
const int _kAuxDataHashInTx          = 255;

const int _requiredMetadataFields = 3;

class CborValidationError implements Exception {
  final String message;
  CborValidationError(this.message);
  @override
  String toString() => 'CborValidationError: $message';
}

class _CborValidator {
  /// Validates CBOR data for metadata or transaction.
  static void validate(List<int> data, String name, {required bool isMetadata, String? context}) {
    cbor.CborValue decoded;
    try {
      decoded = cbor.cbor.decode(data);
    } catch (e) {
      throw CborValidationError('$name: Failed to decode CBOR: $e');
    }

    if (isMetadata) {
      _validateMetadata(decoded, name, context);
    } else {
      _validateTransaction(decoded, name, context);
    }
  }

  /// Validates metadata CBOR structure.
  static void _validateMetadata(cbor.CborValue decoded, String name, String? context) {
    // Expect: [map, [], []]
    if (decoded is! cbor.CborList || decoded.length != 3) {
      throw CborValidationError('$name: Metadata must be a 3-element array');
    }
    final decodedList = decoded as cbor.CborList;
    if (decodedList[1] is! cbor.CborList || (decodedList[1] as cbor.CborList).length != 0) {
      throw CborValidationError('$name: Second element must be an empty array');
    }
    if (decodedList[2] is! cbor.CborList || (decodedList[2] as cbor.CborList).length != 0) {
      throw CborValidationError('$name: Third element must be an empty array');
    }

    // Validate metadata map
    final metadataMap = decodedList[0];
    if (metadataMap is! cbor.CborMap) {
      throw CborValidationError('$name: First element must be a map');
    }

    // Check required keys
    final requiredKeys = {_kPurpose, _kTxInputsHashPlaceholder, _kValidationSignature};
    final mapKeys = metadataMap.keys.map((k) => (k as cbor.CborSmallInt).value).toSet();
    if (!requiredKeys.every((k) => mapKeys.contains(k))) {
      throw CborValidationError('$name: Missing required keys: $requiredKeys');
    }

    // Validate key types and sizes
    for (final entry in metadataMap.entries) {
      final key = (entry.key as cbor.CborSmallInt).value;
      final value = entry.value;

      if (key == _kPurpose) {
        if (value is! cbor.CborBytes || value.bytes.length != _purposeSize) {
          throw CborValidationError('$name: Key 0 must be a $_purposeSize-byte array');
        }
      } else if (key == _kTxInputsHashPlaceholder) {
        if (value is! cbor.CborBytes || value.bytes.length != _txInputsHashSize) {
          throw CborValidationError('$name: Key 1 must be a $_txInputsHashSize-byte array');
        }
      } else if (key == _kValidationSignature) {
        if (value is! cbor.CborBytes || value.bytes.length != _validationSigSize) {
          throw CborValidationError('$name: Key 99 must be a $_validationSigSize-byte array');
        }
      } else {
        // Allow additional keys but ensure they are valid CBOR types
        if (value is! cbor.CborBytes && value is! cbor.CborList && value is! cbor.CborMap) {
          throw CborValidationError('$name: Additional key $key has invalid type');
        }
      }
    }

    // Check for duplicate keys
    if (mapKeys.length != metadataMap.length) {
      throw CborValidationError('$name: Duplicate keys detected in metadata map');
    }

    // Check if placeholders are non-zero after patching
    final inputsHashValue = metadataMap[cbor.CborSmallInt(_kTxInputsHashPlaceholder)];
    if (inputsHashValue is cbor.CborBytes && inputsHashValue.bytes.every((b) => b == 0)) {
      final isExpected = context == 'initial' || context == 'after_tx_inputs_hash_patch';
      final status = isExpected ? 'EXPECTED' : 'UNEXPECTED';
      print('Warning: $name: Inputs hash placeholder is still zero-filled ($status at $context)');
    }
    
    final signatureValue = metadataMap[cbor.CborSmallInt(_kValidationSignature)];
    if (signatureValue is cbor.CborBytes && signatureValue.bytes.every((b) => b == 0)) {
      final isExpected = context == 'initial' || context == 'after_tx_inputs_hash_patch';
      final status = isExpected ? 'EXPECTED' : 'UNEXPECTED';
      print('Warning: $name: Signature placeholder is still zero-filled ($status at $context)');
    }
  }

  /// Validates transaction CBOR structure.
  static void _validateTransaction(cbor.CborValue decoded, String name, String? context) {
    // Expect: [body, witnesses, aux_data_hash]
    if (decoded is! cbor.CborList || decoded.length != 3) {
      throw CborValidationError('$name: Transaction must be a 3-element array');
    }

    // Validate body: [inputs, outputs, fee, ttl]
    final body = decoded[0];
    if (body is! cbor.CborList || body.length != 4) {
      throw CborValidationError('$name: Transaction body must be a 4-element array');
    }

    // Validate inputs array
    final inputs = body[0];
    if (inputs is! cbor.CborList) {
      throw CborValidationError('$name: Inputs must be an array');
    }
    for (final input in inputs) {
      if (input is! cbor.CborList || input.length != 2) {
        throw CborValidationError('$name: Each input must be a 2-element array');
      }
      if (input[0] is! cbor.CborBytes || input[1] is! cbor.CborSmallInt) {
        throw CborValidationError('$name: Input must be [bytes, small int]');
      }
    }

    // Validate outputs array
    final outputs = body[1];
    if (outputs is! cbor.CborList) {
      throw CborValidationError('$name: Outputs must be an array');
    }
    for (final output in outputs) {
      if (output is! cbor.CborList || output.length != 2) {
        throw CborValidationError('$name: Each output must be a 2-element array');
      }
      if (output[0] is! cbor.CborBytes || output[1] is! cbor.CborSmallInt) {
        throw CborValidationError('$name: Output must be [bytes, small int]');
      }
    }

    // Validate fee
    final fee = body[2];
    if (fee is! cbor.CborSmallInt && fee is! cbor.CborInt) {
      throw CborValidationError('$name: Fee must be an integer');
    }
    if ((fee as dynamic).value < 0) {
      throw CborValidationError('$name: Fee must be non-negative');
    }

    // Validate TTL
    final ttl = body[3];
    if (ttl is! cbor.CborSmallInt && ttl is! cbor.CborInt) {
      throw CborValidationError('$name: TTL must be an integer');
    }
    if ((ttl as dynamic).value < 0) {
      throw CborValidationError('$name: TTL must be non-negative');
    }

    // Validate witnesses
    final witnesses = decoded[1];
    if (witnesses is! cbor.CborList) {
      throw CborValidationError('$name: Witnesses must be an array');
    }
    for (final witness in witnesses) {
      if (witness is! cbor.CborBytes || witness.bytes.length != 64) {
        throw CborValidationError('$name: Each witness must be a 64-byte array');
      }
    }

    // Validate auxiliary data hash
    final auxDataHash = decoded[2];
    if (auxDataHash is! cbor.CborBytes || auxDataHash.bytes.length != _metadataHashSize) {
      throw CborValidationError('$name: Auxiliary data hash must be a $_metadataHashSize-byte array');
    }

    // Check if auxiliary data hash is zero-filled
    if (auxDataHash.bytes.every((b) => b == 0)) {
      final isExpected = context == 'initial';
      final status = isExpected ? 'EXPECTED' : 'UNEXPECTED';
      print('Warning: $name: Auxiliary data hash is still zero-filled ($status at $context)');
    }
  }
}

/// Performs in-place byte patching for placeholder replacement.
/// Replaces dummy data with real values without re-encoding.
class _PlaceholderPatcher {
  /// Replaces bytes at specified position with new value.
  /// Validates position and size constraints before patching.
  static void patch(List<int> data, int key, int position, int size, List<int> newValue) {
    if (position + size <= data.length && newValue.length == size) {
      data.setRange(position, position + size, newValue);
    } else {
      throw ArgumentError(
        'Cannot patch key $key at position $position: data_len=${data.length}, size=$size, new_value_len=${newValue.length}'
      );
    }
  }
}

/// Cryptographic operations wrapper for Blake2b-256 hashing and Ed25519 signing.
class _Crypto {
  /// Compute Blake2b-256 hash with variable output length (16 or 32 bytes).
  static List<int> blake2b256(List<int> data, {int outLen = 32}) {
    return Hash.blake2b(Uint8List.fromList(data), digestSize: outLen);
  }

  /// Signs message with Ed25519 using provided secret key.
  static Future<List<int>> ed25519(List<int> msg, List<int> sk) async {
    final algorithm = crypto.Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(Uint8List.fromList(sk));
    final signature = await algorithm.sign(Uint8List.fromList(msg), keyPair: keyPair);
    return signature.bytes;
  }
}

/// Transaction input UTXO
/// CBOR format: [hash, index].
class _TxInput {
  final List<int> hash;
  final int index;
  const _TxInput(this.hash, this.index);

  cbor.CborValue toCbor() => cbor.CborList.of([
        cbor.CborBytes(hash),
        cbor.CborSmallInt(index),
      ]);
}

/// Transaction output
/// CBOR format: [address, amount]
class _TxOutput {
  final List<int> address;
  final int amount;
  const _TxOutput(this.address, this.amount);

  cbor.CborValue toCbor() => cbor.CborList.of([
        cbor.CborBytes(address),
        cbor.CborSmallInt(amount),
      ]);
}

/// Tracks placeholder position and size for in-place patching.
/// Enables single-pass encoding with post-encoding updates.
class _Placeholder {
  final int pos;
  final int size;
  const _Placeholder(this.pos, this.size);
}

/// Represents a byte range within encoded data.
class _Range {
  final int start;
  final int end;
  const _Range(this.start, this.end);
}

/// Tracks byte positions during CBOR encoding for later patching.
class _OffsetCtx {
  final _placeholder = <int, _Placeholder>{};
  _Range? inputsRange;
  int? feePosition;

  /// Records placeholder position for later patching.
  void recordPH(int key, int pos, int size) => _placeholder[key] = _Placeholder(pos, size);
  
  /// Records fee position for dynamic fee updates.
  /// Enables fee balancing without re-encoding transaction body, easier doing separate function
  void recordFeePosition(int pos) => feePosition = pos;
}

/// Custom CBOR sink that tracks byte positions during encoding.
/// Wraps standard CBOR sink despite it being an internal class.
/// Enables position tracking without modifying CBOR library internals.
/// Can commit change to official cbor library if needed and move to public API then
class _TrackingSink extends cbor_internal.EncodeSink {
  final cbor_internal.EncodeSink _inner;
  final _OffsetCtx ctx;

  int _cursor = 0;

  int? _phKey;
  int? _phStart;
  int? _phSize;

  int? _inputsStartTmp;

  _TrackingSink(this._inner, this.ctx);

  @override
  void add(List<int> data) {
    _inner.add(data);
    _cursor += data.length;
  }

  @override
  void close() => _inner.close();

  /// Marks start of placeholder.
  void beginPlaceholder(int key, int size) {
    _phKey = key;
    _phStart = _cursor;
    _phSize = size;
  }

  /// Records final placeholder position after encoding completes.
  void endPlaceholder() {
    if (_phKey == null) return;
    final after = _cursor;
    final header = after - _phStart! - _phSize!;
    final dataPos = _phStart! + header;
    ctx.recordPH(_phKey!, dataPos, _phSize!);
    _phKey = _phStart = _phSize = null;
  }

  /// Marks start of inputs section for hash computation.
  /// Used to compute transaction inputs hash without re-encoding.
  void markInputsStart() => _inputsStartTmp = _cursor;
  
  /// Records input section range for later hashing.
  void markInputsEnd() {
    if (_inputsStartTmp != null) {
      ctx.inputsRange = _Range(_inputsStartTmp!, _cursor);
      _inputsStartTmp = null;
    }
  }

  /// Records fee position for dynamic fee updates.
  /// Enables fee balancing without reencoding transaction body.
  void markFeeStart() => ctx.recordFeePosition(_cursor);
}

/// Builds and encodes Catalyst transaction metadata with placeholders.
/// Creates metadata map with required fields (purpose, inputs hash, signature).
/// Uses placeholders for fields that depend on transaction content or signatures.
class _MetadataBuilder {
  /// Creates metadata map with placeholders for dynamic content.
  /// Required fields: purpose, inputs hash, signature.
  /// Additional metadata can be added later if required.
  static Map<String, dynamic> createAndEncodeMetadata({
    required Map<int, List<int>> additionalMetadata,
    required List<int> purpose,
  }) {
    final ctx = _OffsetCtx();
    final out = Uint8Buffer();
    final sink = _TrackingSink(cbor_internal.EncodeSink.withBuffer(out), ctx);

    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(3));

    final mapSize = _requiredMetadataFields + additionalMetadata.length;
    sink.addHeaderInfo(cbor.CborMajorType.map, Arg.int(mapSize));

    cbor.CborSmallInt(_kPurpose).encode(sink);
    cbor.CborBytes(purpose).encode(sink);

    cbor.CborSmallInt(_kTxInputsHashPlaceholder).encode(sink);
    sink.beginPlaceholder(_kTxInputsHashPlaceholder, _txInputsHashSize);
    cbor.CborBytes(List<int>.filled(_txInputsHashSize, 0)).encode(sink);
    sink.endPlaceholder();

    cbor.CborSmallInt(_kValidationSignature).encode(sink);
    sink.beginPlaceholder(_kValidationSignature, _validationSigSize);
    cbor.CborBytes(List<int>.filled(_validationSigSize, 0)).encode(sink);
    sink.endPlaceholder();

    for (final e in additionalMetadata.entries) {
      cbor.CborSmallInt(e.key).encode(sink);
      cbor.CborBytes(e.value).encode(sink);
    }

    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(0));
    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(0));

    sink.close();
    return {'bytes': out.toList(), 'ctx': ctx};
  }
}

/// Builds and encodes transactions with position tracking.
/// Creates transaction body with inputs, outputs, fee, TTL, witnesses, and metadata hash.
class _TransactionBuilder {
  /// Creates transaction with dynamic UTXO selection.
  /// Sould use the fee calculation and other logic from the UTXO selector previously implemented.
  static Map<String, dynamic> createAndEncodeTransactionWithUTXOSelection({
    required List<_UTXO> availableUTXOs,
    required List<_TxOutput> targetOutputs,
    int ttl = 0,
  }) {
    // Use UTXO selector to choose optimal inputs and calculate fees
    final selector = _UTXOSelector(
      availableUTXOs: availableUTXOs,
      targetOutputs: targetOutputs,
    );
    
    final selection = selector.selectUTXOs();
    final inputs = selection['inputs'] as List<_TxInput>;
    final outputs = selection['outputs'] as List<_TxOutput>;
    final fee = selection['fee'] as int;
    final changeAmount = selection['changeAmount'] as int;
    
    // Create transaction with selected inputs and outputs
    return createAndEncodeTransaction(
      inputs: inputs,
      outputs: outputs,
      fee: fee,
      ttl: ttl,
    );
  }

  /// Calculates required witness count based on input types. Demo only
  static int _calculateWitnessCount(List<_TxInput> inputs) {
    return inputs.length;
  }

  /// Creates and encodes transaction with position tracking for patching.
  /// Structure: [body, witnesses, auxiliary_data_hash].
  static Map<String, dynamic> createAndEncodeTransaction({
    required List<_TxInput> inputs,
    required List<_TxOutput> outputs,
    required int fee,
    int ttl = 0,
  }) {
    final ctx = _OffsetCtx();
    final out = Uint8Buffer();
    final sink = _TrackingSink(cbor_internal.EncodeSink.withBuffer(out), ctx);

    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(3));

    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(4));

    sink.markInputsStart();
    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(inputs.length));
    for (final i in inputs) i.toCbor().encode(sink);
    sink.markInputsEnd();

    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(outputs.length));
    for (final o in outputs) o.toCbor().encode(sink);

    sink.markFeeStart();
    cbor.CborSmallInt(fee).encode(sink);

    cbor.CborSmallInt(ttl).encode(sink);

    final witnessCount = _calculateWitnessCount(inputs);
    final witnessDummy = List<int>.filled(_witnessSize, 0);
    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(witnessCount));
    for (var i = 0; i < witnessCount; i++) {
      cbor.CborBytes(witnessDummy).encode(sink);
    }

    sink.beginPlaceholder(_kAuxDataHashInTx, _metadataHashSize);
    cbor.CborBytes(List<int>.filled(_metadataHashSize, 0)).encode(sink);
    sink.endPlaceholder();

    sink.close();
    return {'bytes': out.toList(), 'ctx': ctx};
  }
}

/// Main transaction processor.
/// Tie into existing code workflow
class _TransactionProcessor {
  final List<int> _signingKey;

  _TransactionProcessor() : _signingKey = List<int>.generate(_signingKeySize, (i) => i ^ 0x55);

  /// Processes transaction through complete workflow, tie into existing code workflow
  Future<Map<String, dynamic>> processTransaction({
    required List<int> metadataBytes,
    required List<int> transactionBytes,
    required _OffsetCtx metadataCtx,
    required _OffsetCtx transactionCtx,
  }) async {
    /// Validates initial CBOR data integrity
    _CborValidator.validate(metadataBytes, 'Initial metadata', isMetadata: true, context: 'initial');
    _CborValidator.validate(transactionBytes, 'Initial transaction', isMetadata: false, context: 'initial');

    /// Computes transaction inputs hash from encoded bytes
    final inStart = transactionCtx.inputsRange!.start;
    final inEnd = transactionCtx.inputsRange!.end;
    final encodedInputs = transactionBytes.sublist(inStart, inEnd);
    final txInputsHash = _Crypto.blake2b256(encodedInputs, outLen: _txInputsHashSize);

    /// Patches inputs hash placeholder in metadata
    final pos1 = metadataCtx._placeholder[_kTxInputsHashPlaceholder]!.pos;
    _PlaceholderPatcher.patch(metadataBytes, _kTxInputsHashPlaceholder, pos1, _txInputsHashSize, txInputsHash);
    _CborValidator.validate(metadataBytes, 'Metadata after tx_inputs_hash patch', isMetadata: true, context: 'after_tx_inputs_hash_patch');

    /// Signs metadata with Ed25519 and patches signature placeholder
    final sig = await _Crypto.ed25519(metadataBytes, _signingKey);
    final posSig = metadataCtx._placeholder[_kValidationSignature]!.pos;
    _PlaceholderPatcher.patch(metadataBytes, _kValidationSignature, posSig, _validationSigSize, sig);
    _CborValidator.validate(metadataBytes, 'Metadata after signature patch', isMetadata: true, context: 'after_signature_patch');

    /// Computes final metadata hash and patches transaction
    final finalMetadataHash = _Crypto.blake2b256(metadataBytes);
    final posAux = transactionCtx._placeholder[_kAuxDataHashInTx]!.pos;
    _PlaceholderPatcher.patch(transactionBytes, _kAuxDataHashInTx, posAux, _metadataHashSize, finalMetadataHash);
    _CborValidator.validate(transactionBytes, 'Final transaction', isMetadata: false, context: 'final_transaction');

    return {
      'transaction': transactionBytes,
      'metadata': metadataBytes,
    };
  }

  /// Updates transaction fee in-place without re-encoding.
  void updateFee(List<int> transactionBytes, _OffsetCtx ctx, int newFee) {
    if (ctx.feePosition == null) {
      throw ArgumentError('No fee position recorded');
    }

    final feeBytes = cbor.cbor.encode(cbor.CborSmallInt(newFee));
    final feeSize = feeBytes.length;

    if (ctx.feePosition! + feeSize > transactionBytes.length) {
      throw ArgumentError('Not enough space to update fee');
    }

    transactionBytes.setRange(ctx.feePosition!, ctx.feePosition! + feeSize, feeBytes);
  }
}

/// Represents UTXO
class _UTXO {
  final List<int> txHash;
  final int outputIndex;
  final List<int> address;
  final int amount;
  
  const _UTXO({
    required this.txHash,
    required this.outputIndex,
    required this.address,
    required this.amount,
  });

  _TxInput toTxInput() => _TxInput(txHash, outputIndex);
  
  _TxOutput toTxOutput() => _TxOutput(address, amount);
}

/// Dummy UTXO selection system that mimics existing selection code
/// This will be completley replaced with existing code
/// Only here to get complete view of the proceess to see if it works
class _UTXOSelector {
  /// Available UTXOs for selection.
  final List<_UTXO> availableUTXOs;
  
  final List<_TxOutput> targetOutputs;
  
  /// Base fee for transaction 
  final int baseFee;
  
  /// Fee per byte for transaction size
  final int feePerByte;
  
  _UTXOSelector({
    required this.availableUTXOs,
    required this.targetOutputs,
    this.baseFee = 155381,
    this.feePerByte = 44,
  });

  /// Selects UTXOs to cover target outputs plus fees.
  Map<String, dynamic> selectUTXOs() {
    // just return first UTXO and fixed fee
    final selectedUTXO = availableUTXOs.first;
    final selectedInputs = [selectedUTXO.toTxInput()];
    final calculatedFee = 170000; // Fixed fee for demo
    final changeAmount = selectedUTXO.amount - targetOutputs.fold<int>(0, (sum, output) => sum + output.amount) - calculatedFee;
    
    final changeOutput = changeAmount > 0 
        ? _TxOutput(selectedUTXO.address, changeAmount) 
        : null;
    
    return {
      'inputs': selectedInputs,
      'outputs': [...targetOutputs, if (changeOutput != null) changeOutput],
      'fee': calculatedFee,
      'changeAmount': changeAmount,
    };
  }
}

/// Creates dummy UTXOs for demonstration purposes.
class _UTXOCreator {
  /// Creates a realistic set of dummy UTXOs.
  static List<_UTXO> createDummyUTXOs() {
    return [
      _UTXO(
        txHash: List<int>.filled(_txInputHashSize, 1),
        outputIndex: 0,
        address: List<int>.filled(_txOutputAddressSize, 10),
        amount: 2000000,
      ),
      _UTXO(
        txHash: List<int>.filled(_txInputHashSize, 2),
        outputIndex: 1,
        address: List<int>.filled(_txOutputAddressSize, 10),
        amount: 1500000, 
      )
    ];
  }
  
  /// Creates target outputs for a transaction.
  /// Same address for us for now
  static List<_TxOutput> createTargetOutputs() {
    return [
      _TxOutput(
        List<int>.filled(_txOutputAddressSize, 20),
        1000000,
      ),
    ];
  }
}

/// Single-pass encoding with in-place patching Demo 
void main() async {
  /// Creates transaction processor with signing key
  final processor = _TransactionProcessor();
  /// Runs transaction building demo
  await _processTransactionDemo(processor);
}

/// Single-pass encoding with in-place patching Demo 
Future<void> _processTransactionDemo(_TransactionProcessor processor) async {
  final additionalMetadata = {
    100: [1, 2, 3, 4, 5],
    200: [6, 7, 8, 9, 10],
    300: [11, 12, 13, 14, 15],
  };

  final purpose = List<int>.generate(_purposeSize, (i) => i + 1);

  final metadata = _MetadataBuilder.createAndEncodeMetadata(
    additionalMetadata: additionalMetadata,
    purpose: purpose,
  );
  final metadataBytes = metadata['bytes'] as List<int>;
  final metadataCtx = metadata['ctx'] as _OffsetCtx;

  // Use UTXO selection dummy for demo
  final availableUTXOs = _UTXOCreator.createDummyUTXOs();
  final targetOutputs = _UTXOCreator.createTargetOutputs();
 
  
  final transaction = _TransactionBuilder.createAndEncodeTransactionWithUTXOSelection(
    availableUTXOs: availableUTXOs,
    targetOutputs: targetOutputs,
  );

  final transactionBytes = transaction['bytes'] as List<int>;
  final transactionCtx = transaction['ctx'] as _OffsetCtx;

  final result = await processor.processTransaction(
    metadataBytes: metadataBytes,
    transactionBytes: transactionBytes,
    metadataCtx: metadataCtx,
    transactionCtx: transactionCtx,
  );

  print('  Processing complete');
}