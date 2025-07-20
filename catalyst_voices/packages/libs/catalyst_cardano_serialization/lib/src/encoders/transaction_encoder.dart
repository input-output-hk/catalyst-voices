import 'dart:typed_data';

import 'package:cbor/cbor.dart' as cbor;
import 'package:cbor/src/encoder/sink.dart' as cbor_internal;
import 'package:cbor/src/utils/arg.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:pinenacl/digests.dart';
import 'package:typed_data/typed_buffers.dart';

import '../builders/transaction_builder.dart';
import '../transaction.dart';
import '../witness.dart';

// Constants from POC
const int _txInputsHashSize = 16;
const int _validationSigSize = 64;
const int _metadataHashSize = 32;
const int _signingKeySize = 32;
const int _purposeSize = 16;

const int _kPurpose = 0;
const int _kTxInputsHashPlaceholder = 1;
const int _kValidationSignature = 99;
const int _kAuxDataHashInTx = 255;
const int _kWitnessSetPlaceholder = 256;

const int _requiredMetadataFields = 3;

/// Error thrown when CBOR validation fails
class CborValidationError implements Exception {
  /// Creates a new CBOR validation error with the given message
  const CborValidationError(this.message);

  /// The error message
  final String message;

  @override
  String toString() => 'CborValidationError: $message';
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
  int? txBodyEnd;
  int? witnessSetPosition;
  int? witnessSetSize;

  /// Records placeholder position for later patching.
  void recordPH(int key, int pos, int size) => _placeholder[key] = _Placeholder(pos, size);
  
  /// Records fee position for dynamic fee updates.
  void recordFeePosition(int pos) => feePosition = pos;

  /// Records transaction body end position.
  void recordTxBodyEnd(int pos) => txBodyEnd = pos;

  /// Records witness set position for in-place patching.
  void recordWitnessSetPosition(int pos) => witnessSetPosition = pos;

  /// Records witness set size for in-place patching.
  void recordWitnessSetSize(int size) => witnessSetSize = size;
}

/// Custom CBOR sink that tracks byte positions during encoding.
/// Wraps standard CBOR sink to enable position tracking without modifying CBOR library internals.
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
  void markInputsStart() => _inputsStartTmp = _cursor;
  
  /// Records input section range for later hashing.
  void markInputsEnd() {
    if (_inputsStartTmp != null) {
      ctx.inputsRange = _Range(_inputsStartTmp!, _cursor);
      _inputsStartTmp = null;
    }
  }

  /// Records fee position for dynamic fee updates.
  void markFeeStart() => ctx.recordFeePosition(_cursor);

  /// Records transaction body end position.
  void markTxBodyEnd() => ctx.recordTxBodyEnd(_cursor);

  /// Records witness set start position for in-place patching.
  void markWitnessSetStart() => ctx.recordWitnessSetPosition(_cursor);

  /// Records witness set end position and size for in-place patching.
  void markWitnessSetEnd() {
    if (ctx.witnessSetPosition != null) {
      ctx.recordWitnessSetSize(_cursor - ctx.witnessSetPosition!);
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

int _extractIntValue(cbor.CborValue value) {
  if (value is cbor.CborSmallInt) {
    return value.value;
  } else if (value is cbor.CborInt) {
    return (value as dynamic).value as int;
  } else {
    throw ArgumentError('Expected CborSmallInt or CborInt, got ${value.runtimeType}');
  }
}

/// CBOR validator for metadata and transaction structures.
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
    final mapKeys = metadataMap.keys.map((k) => _extractIntValue(k as cbor.CborValue)).toSet();
    if (!requiredKeys.every((k) => mapKeys.contains(k))) {
      throw CborValidationError('$name: Missing required keys: $requiredKeys');
    }

    // Validate key types and sizes
    for (final entry in metadataMap.entries) {
      final key = _extractIntValue(entry.key as cbor.CborValue);
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
      }
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
    if (body is! cbor.CborList || body.length < 3) {
      throw CborValidationError('$name: Transaction body must be at least a 3-element array');
    }

    // Validate fee
    final fee = body[2];
    if (fee is! cbor.CborSmallInt && fee is! cbor.CborInt) {
      throw CborValidationError('$name: Fee must be an integer');
    }
    final feeValue = _extractIntValue(fee);
    if (feeValue < 0) {
      throw CborValidationError('$name: Fee must be non-negative');
    }
  }
}

/// Generic transaction encoder with in-place patching capabilities.
class TransactionEncoder {
  final List<int> _signingKey;

  /// Creates a TransactionEncoder with a required signing key.
  /// A valid signing key must be provided for cryptographic operations.
  /// 
  /// Throws [ArgumentError] if signingKey is null or invalid.
  TransactionEncoder({required List<int> signingKey})
      : _signingKey = signingKey {
    if (signingKey.isEmpty) {
      throw ArgumentError('Signing key cannot be empty');
    }
    if (signingKey.length != _signingKeySize) {
      throw ArgumentError('Signing key must be exactly $_signingKeySize bytes, got ${signingKey.length}');
    }
  }

  /// Builds a transaction with optional metadata processing and in-place patching.
  /// This is a generic method that can be used for any transaction type.
  Future<TransactionWithContext> buildTransactionWithPatching({
    required TransactionBuilder builder,
    AuxiliaryData? auxiliaryData,
    Map<int, List<int>>? additionalMetadata,
    List<int>? purpose,
  }) async {
    // Apply UTXO selection using the builder's coin selection strategy
    final builderWithSelection = builder.applySelection();

    // If metadata with placeholders is requested, create transaction with full patching
    if (additionalMetadata != null && purpose != null) {
      return _createTransactionWithMetadataPatching(
        builderWithSelection,
        additionalMetadata,
        purpose,
      );
    }

    // If auxiliaryData is provided, use it directly
    if (auxiliaryData != null) {
      final txBuilderWithAux = TransactionBuilder(
        config: builderWithSelection.config,
        inputs: builderWithSelection.inputs,
        outputs: builderWithSelection.outputs,
        fee: builderWithSelection.fee,
        ttl: builderWithSelection.ttl,
        auxiliaryData: auxiliaryData,
        validityStart: builderWithSelection.validityStart,
        mint: builderWithSelection.mint,
        scriptData: builderWithSelection.scriptData,
        collateralInputs: builderWithSelection.collateralInputs,
        requiredSigners: builderWithSelection.requiredSigners,
        networkId: builderWithSelection.networkId,
        collateralReturn: builderWithSelection.collateralReturn,
        totalCollateral: builderWithSelection.totalCollateral,
        referenceInputs: builderWithSelection.referenceInputs,
        witnessBuilder: builderWithSelection.witnessBuilder,
        changeAddress: builderWithSelection.changeAddress,
      );
      
      final txBody = txBuilderWithAux.buildBody();
      final transaction = Transaction(
        body: txBody,
        isValid: true,
        witnessSet: const TransactionWitnessSet(),
        auxiliaryData: auxiliaryData,
      );
      
      return TransactionWithContext(transaction: transaction);
    }

    // Create standard transaction with position tracking
    return _createTransactionWithPositionTracking(builderWithSelection);
  }

  /// Creates a transaction with complete metadata processing and cryptographic signatures.
  Future<TransactionWithContext> _createTransactionWithMetadataPatching(
    TransactionBuilder builder,
    Map<int, List<int>> additionalMetadata,
    List<int> purpose,
  ) async {
    // Step 1: Create metadata with placeholders
    final metadataResult = _createMetadataWithPlaceholders(
      additionalMetadata: additionalMetadata,
      purpose: purpose,
    );
    final metadataBytes = metadataResult['bytes'] as List<int>;
    final metadataCtx = metadataResult['ctx'] as _OffsetCtx;

    // Step 2: Create transaction with position tracking
    final txResult = _createTransactionWithTracking(builder);
    final txBytes = txResult['bytes'] as List<int>;
    final txCtx = txResult['ctx'] as _OffsetCtx;

    // Step 3: Validate initial CBOR structures
    _CborValidator.validate(metadataBytes, 'Initial metadata', isMetadata: true, context: 'initial');
    _CborValidator.validate(txBytes, 'Initial transaction', isMetadata: false, context: 'initial');

    // Step 4: Compute transaction inputs hash
    final inStart = txCtx.inputsRange!.start;
    final inEnd = txCtx.inputsRange!.end;
    final encodedInputs = txBytes.sublist(inStart, inEnd);
    final txInputsHash = _Crypto.blake2b256(encodedInputs, outLen: _txInputsHashSize);

    // Step 5: Patch inputs hash placeholder in metadata
    final pos1 = metadataCtx._placeholder[_kTxInputsHashPlaceholder]!.pos;
    _PlaceholderPatcher.patch(metadataBytes, _kTxInputsHashPlaceholder, pos1, _txInputsHashSize, txInputsHash);
    _CborValidator.validate(metadataBytes, 'Metadata after tx_inputs_hash patch', isMetadata: true, context: 'after_tx_inputs_hash_patch');

    // Step 6: Sign metadata with Ed25519 and patch signature placeholder
    final sig = await _Crypto.ed25519(metadataBytes, _signingKey);
    final posSig = metadataCtx._placeholder[_kValidationSignature]!.pos;
    _PlaceholderPatcher.patch(metadataBytes, _kValidationSignature, posSig, _validationSigSize, sig);
    _CborValidator.validate(metadataBytes, 'Metadata after signature patch', isMetadata: true, context: 'after_signature_patch');

    // Step 7: Compute final metadata hash and patch transaction
    final finalMetadataHash = _Crypto.blake2b256(metadataBytes);
    final posAux = txCtx._placeholder[_kAuxDataHashInTx]!.pos;
    _PlaceholderPatcher.patch(txBytes, _kAuxDataHashInTx, posAux, _metadataHashSize, finalMetadataHash);
    _CborValidator.validate(txBytes, 'Final transaction', isMetadata: false, context: 'final_transaction');

    // Step 8: Reconstruct Transaction object from processed data
    final finalTransaction = _reconstructTransactionFromBytes(txBytes);

    return TransactionWithContext(
      transaction: finalTransaction,
      metadataBytes: metadataBytes,
      transactionBytes: txBytes,
      metadataContext: metadataCtx,
      transactionContext: txCtx,
    );
  }

  /// Creates a transaction with position tracking for later in-place updates.
  TransactionWithContext _createTransactionWithPositionTracking(TransactionBuilder builder) {
    final txResult = _createTransactionWithTracking(builder);
    final txBytes = txResult['bytes'] as List<int>;
    final txCtx = txResult['ctx'] as _OffsetCtx;

    final transaction = _reconstructTransactionFromBytes(txBytes);

    return TransactionWithContext(
      transaction: transaction,
      transactionBytes: txBytes,
      transactionContext: txCtx,
    );
  }

  /// Creates metadata with placeholders
  Map<String, dynamic> _createMetadataWithPlaceholders({
    required Map<int, List<int>> additionalMetadata,
    required List<int> purpose,
  }) {
    final ctx = _OffsetCtx();
    final out = Uint8Buffer();
    final sink = _TrackingSink(cbor_internal.EncodeSink.withBuffer(out), ctx);

    // Start metadata array [metadata_map, [], []]
    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(3));

    // Create metadata map
    final mapSize = _requiredMetadataFields + additionalMetadata.length;
    sink.addHeaderInfo(cbor.CborMajorType.map, Arg.int(mapSize));

    // Purpose (key 0)
    cbor.CborSmallInt(_kPurpose).encode(sink);
    cbor.CborBytes(purpose).encode(sink);

    // Transaction inputs hash placeholder (key 1)
    cbor.CborSmallInt(_kTxInputsHashPlaceholder).encode(sink);
    sink.beginPlaceholder(_kTxInputsHashPlaceholder, _txInputsHashSize);
    cbor.CborBytes(List<int>.filled(_txInputsHashSize, 0)).encode(sink);
    sink.endPlaceholder();

    // Validation signature placeholder (key 99)
    cbor.CborSmallInt(_kValidationSignature).encode(sink);
    sink.beginPlaceholder(_kValidationSignature, _validationSigSize);
    cbor.CborBytes(List<int>.filled(_validationSigSize, 0)).encode(sink);
    sink.endPlaceholder();

    // Additional metadata
    for (final e in additionalMetadata.entries) {
      cbor.CborSmallInt(e.key).encode(sink);
      cbor.CborBytes(e.value).encode(sink);
    }

    // Empty arrays for metadata structure
    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(0));
    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(0));

    sink.close();
    return {'bytes': out.toList(), 'ctx': ctx};
  }

  /// Creates transaction with position tracking using the TransactionBuilder.
  Map<String, dynamic> _createTransactionWithTracking(TransactionBuilder builder) {
    final ctx = _OffsetCtx();
    final out = Uint8Buffer();
    final sink = _TrackingSink(cbor_internal.EncodeSink.withBuffer(out), ctx);

    // Build the transaction body using the real builder
    final txBody = builder.buildBody();
    final fullTx = builder.buildFakeTransaction(txBody);

    // Calculate actual witness set size based on inputs
    final witnessSetSize = _calculateWitnessSetSize(txBody.inputs.length);

    // Encode transaction with position tracking
    // Transaction structure: [body, witnesses, auxiliary_data_hash]
    sink.addHeaderInfo(cbor.CborMajorType.array, Arg.int(3));

    // Encode body with input tracking
    _encodeTransactionBodyWithTracking(sink, ctx, txBody);
    
    // Encode witness set placeholder with position tracking
    sink.markWitnessSetStart();
    sink.beginPlaceholder(_kWitnessSetPlaceholder, witnessSetSize);
    cbor.CborBytes(List<int>.filled(witnessSetSize, 0)).encode(sink);
    sink.endPlaceholder();
    sink.markWitnessSetEnd();
    
    // Encode auxiliary data hash placeholder
    sink.beginPlaceholder(_kAuxDataHashInTx, _metadataHashSize);
    cbor.CborBytes(List<int>.filled(_metadataHashSize, 0)).encode(sink);
    sink.endPlaceholder();

    sink.markTxBodyEnd();
    sink.close();

    return {'bytes': out.toList(), 'ctx': ctx};
  }

  /// Calculates the actual witness set size based on number of inputs.
  /// Each input requires a VkeyWitness (public key + signature).
  int _calculateWitnessSetSize(int inputCount) {
    // Each VkeyWitness is: [publicKey, signature]
    // publicKey: 32 bytes (Ed25519)
    // signature: 64 bytes (Ed25519)
    const int witnessOverhead = 4;
    const int publicKeySize = 32;
    const int signatureSize = 64;
    const int witnessSize = publicKeySize + signatureSize + witnessOverhead;
    
    // Witness set is an array of witnesses
    const int arrayOverhead = 2; // CBOR array header
    
    return arrayOverhead + (inputCount * witnessSize);
  }

  /// Encodes transaction body with input position tracking.
  void _encodeTransactionBodyWithTracking(_TrackingSink sink, _OffsetCtx ctx, TransactionBody txBody) {
    final bodyMap = <cbor.CborValue, cbor.CborValue>{};
    
    // Inputs (key 0) with position tracking
    sink.markInputsStart();
    bodyMap[cbor.CborSmallInt(0)] = cbor.CborList.of(
      txBody.inputs.map((input) => input.toCbor()).toList(),
    );
    sink.markInputsEnd();

    // Outputs (key 1)
    bodyMap[cbor.CborSmallInt(1)] = cbor.CborList.of(
      txBody.outputs.map((output) => output.toCbor()).toList(),
    );

    // Fee (key 2) with position tracking
    sink.markFeeStart();
    bodyMap[cbor.CborSmallInt(2)] = cbor.CborSmallInt(txBody.fee.value);

    // Add other fields if present
    if (txBody.ttl != null) {
      bodyMap[cbor.CborSmallInt(3)] = cbor.CborSmallInt(txBody.ttl!.value);
    }
    if (txBody.auxiliaryDataHash != null) {
      bodyMap[cbor.CborSmallInt(7)] = cbor.CborBytes(txBody.auxiliaryDataHash!.bytes);
    }
    if (txBody.validityStart != null) {
      bodyMap[cbor.CborSmallInt(8)] = cbor.CborSmallInt(txBody.validityStart!.value);
    }

    // Encode the body map
    cbor.CborMap(bodyMap).encode(sink);
  }

  /// Reconstructs Transaction object from encoded bytes.
  /// Throws [CborValidationError] if the transaction cannot be reconstructed.
  Transaction _reconstructTransactionFromBytes(List<int> bytes) {
    try {
      final decoded = cbor.cbor.decode(bytes);
      return Transaction.fromCbor(decoded);
    } catch (e) {
      throw CborValidationError(
        'Failed to reconstruct transaction from encoded bytes: $e. '
        'Critical encoding/decoding mismatch.'
      );
    }
  }

  /// Updates transaction fee in-place using position tracking.
  void updateFeeInPlace(List<int> transactionBytes, _OffsetCtx ctx, int newFee) {
    if (ctx.feePosition == null) {
      throw ArgumentError('No fee position recorded for in-place update');
    }

    // Encode new fee
    final newFeeBytes = cbor.cbor.encode(cbor.CborSmallInt(newFee));
    
    // Calculate available space for fee update
    final availableSpace = ctx.txBodyEnd != null 
        ? ctx.txBodyEnd! - ctx.feePosition! 
        : transactionBytes.length - ctx.feePosition!;

    if (newFeeBytes.length > availableSpace) {
      throw ArgumentError('New fee encoding is too large for available space');
    }

    // Perform in-place update
    transactionBytes.setRange(
      ctx.feePosition!, 
      ctx.feePosition! + newFeeBytes.length, 
      newFeeBytes
    );

    // Clear any remaining bytes if the new fee is smaller
    if (newFeeBytes.length < availableSpace) {
      final remaining = availableSpace - newFeeBytes.length;
      transactionBytes.fillRange(
        ctx.feePosition! + newFeeBytes.length,
        ctx.feePosition! + newFeeBytes.length + remaining,
        0
      );
    }
  }

  /// Patches witness set in-place using position tracking.
  void patchWitnessSetInPlace(
    List<int> transactionBytes, 
    _OffsetCtx ctx, 
    TransactionWitnessSet witnessSet
  ) {
    if (ctx._placeholder[_kWitnessSetPlaceholder] == null) {
      throw ArgumentError('No witness set placeholder recorded for in-place update');
    }

    // Encode the real witness set
    final realWitnessBytes = cbor.cbor.encode(witnessSet.toCbor());
    final placeholder = ctx._placeholder[_kWitnessSetPlaceholder]!;
    
    // Perform in-place patching
    _PlaceholderPatcher.patch(
      transactionBytes,
      _kWitnessSetPlaceholder,
      placeholder.pos,
      placeholder.size,
      realWitnessBytes,
    );
  }
}

/// Container class for transaction with context information for in-place patching.
class TransactionWithContext {
  /// The constructed transaction
  final Transaction transaction;

  /// Raw metadata bytes for additional processing
  final List<int>? metadataBytes;

  /// Raw transaction bytes with position tracking
  final List<int>? transactionBytes;

  /// Context for metadata placeholders and positions
  final _OffsetCtx? metadataContext;

  /// Context for transaction placeholders and positions
  final _OffsetCtx? transactionContext;

  /// Creates a TransactionWithContext.
  const TransactionWithContext({
    required this.transaction,
    this.metadataBytes,
    this.transactionBytes,
    this.metadataContext,
    this.transactionContext,
  });

  /// Returns true if this transaction supports in-place fee updates.
  bool get supportsInPlaceFeeUpdates => 
      transactionBytes != null && transactionContext?.feePosition != null;

  /// Returns true if this transaction has metadata with placeholders.
  bool get hasMetadataPlaceholders => 
      metadataBytes != null && metadataContext != null;

  /// Returns true if this transaction supports in-place witness set updates.
  bool get supportsInPlaceWitnessUpdates => 
      transactionBytes != null && transactionContext?._placeholder[_kWitnessSetPlaceholder] != null;
} 
