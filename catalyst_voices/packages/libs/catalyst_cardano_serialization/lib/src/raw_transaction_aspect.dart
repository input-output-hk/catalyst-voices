import 'package:catalyst_cardano_serialization/src/raw_transaction.dart';
import 'package:catalyst_cardano_serialization/src/rbac/x509_metadata_envelope.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';

/// Internal helper class for [RawTransaction].
enum RawTransactionAspect {
  /// See [TransactionBody.inputs].
  inputs,

  /// See [TransactionBody.outputs].
  outputs,

  /// See [TransactionBody.fee].
  fee,

  /// See [X509MetadataEnvelope.txInputsHash].
  txInputsHash,

  /// See [Transaction.auxiliaryData].
  auxiliaryData,

  /// See [TransactionBody.auxiliaryDataHash].
  auxiliaryDataHash,

  /// See [TransactionBody.requiredSigners].
  requiredSigners,

  /// See [TransactionBody.networkId].
  networkId,

  /// See [X509MetadataEnvelope.validationSignature].
  signature,

  /// See [Transaction.witnessSet].
  witnessSet,
}
