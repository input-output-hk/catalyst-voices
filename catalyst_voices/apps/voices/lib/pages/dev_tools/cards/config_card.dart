import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/dev_tools/cards/info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/value_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ConfigCard extends StatelessWidget {
  const ConfigCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, AppConfig?>(
      selector: (state) => state.systemInfo?.config,
      builder: (context, state) {
        return _ConfigCard(
          networkId: state?.blockchain.networkId,
          host: state?.blockchain.host,
          // TODO(damian-molinski): use DTO after #2135 is merged.
          transactionBuilderConfig: state?.blockchain.transactionBuilderConfig.asMap(),
        );
      },
    );
  }
}

class _ConfigCard extends StatelessWidget {
  final NetworkId? networkId;
  final CatalystIdHost? host;
  final Map<String, dynamic>? transactionBuilderConfig;

  const _ConfigCard({
    this.networkId,
    this.host,
    this.transactionBuilderConfig,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: const Text('Config'),
      children: [
        ValueText(name: const Text('NetworkId'), value: Text(networkId?.name ?? '-')),
        ValueText(name: const Text('Host'), value: Text(host?.name ?? '-')),
        ValueText(
          name: const Text('TransactionBuilderConfig'),
          value: Text('${transactionBuilderConfig ?? {}}'),
        ),
      ],
    );
  }
}

extension on TransactionBuilderConfig {
  Map<String, dynamic> asMap() {
    return {
      'feeAlgo': {
        'constant': feeAlgo.constant,
        'coefficient': feeAlgo.coefficient,
        'multiplier': feeAlgo.multiplier,
        'sizeIncrement': feeAlgo.sizeIncrement,
        'refScriptByteCost': feeAlgo.refScriptByteCost,
        'maxRefScriptSize': feeAlgo.maxRefScriptSize,
      },
      'maxTxSize': maxTxSize,
      'maxValueSize': maxValueSize,
      'coinsPerUtxoByte': CryptocurrencyFormatter.formatExactAmount(coinsPerUtxoByte),
      'selectionStrategy': selectionStrategy.runtimeType.toString(),
    };
  }
}
