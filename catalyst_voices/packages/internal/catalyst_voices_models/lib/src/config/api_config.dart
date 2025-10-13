import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ApiConfig extends Equatable {
  final AppEnvironmentType env;
  final LocalGatewayConfig localGateway;

  const ApiConfig({
    required this.env,
    this.localGateway = const LocalGatewayConfig.disabled(),
  });

  @override
  List<Object?> get props => [env, localGateway];
}

final class LocalGatewayConfig extends Equatable {
  final bool isEnabled;
  final int proposalsCount;
  final bool decompressedDocuments;

  const LocalGatewayConfig({
    this.isEnabled = false,
    this.proposalsCount = 100,
    this.decompressedDocuments = false,
  });

  const LocalGatewayConfig.disabled()
    : isEnabled = false,
      proposalsCount = 0,
      decompressedDocuments = false;

  LocalGatewayConfig.stressTest(StressTestConfig config)
    : this(
        isEnabled: config.isEnabled,
        proposalsCount: config.indexedProposalsCount,
        decompressedDocuments: config.decompressedDocuments,
      );

  @override
  List<Object?> get props => [
    isEnabled,
    proposalsCount,
    decompressedDocuments,
  ];
}
