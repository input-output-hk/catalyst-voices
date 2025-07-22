import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart' as cs
    show Ed25519PublicKey;
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_role.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy.dart';

final class RegistrationTransactionStrategyBytes implements RegistrationTransactionStrategy {
  final TransactionBuilderConfig transactionConfig;
  final NetworkId networkId;
  final SlotBigNum slotNumberTtl;
  final Set<RegistrationTransactionRole> roles;
  final ShelleyAddress changeAddress;
  final Set<TransactionUnspentOutput> utxos;
  final TransactionHash? previousTransactionId;

  RegistrationTransactionStrategyBytes({
    required this.transactionConfig,
    required this.networkId,
    required this.slotNumberTtl,
    required this.roles,
    required this.changeAddress,
    required this.utxos,
    required this.previousTransactionId,
  });

  @override
  Future<BaseTransaction> build({
    required String purpose,
    required CatalystKeyPair rootKeyPair,
    required X509DerCertificate? derCert,
    required List<RbacField<cs.Ed25519PublicKey>> publicKeys,
    required Set<Ed25519PublicKeyHash> requiredSigners,
  }) async {
    throw UnimplementedError();
  }
}
