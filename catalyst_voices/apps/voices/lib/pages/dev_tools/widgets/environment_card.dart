import 'package:catalyst_voices/pages/dev_tools/cards/info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/value_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class EnvironmentCard extends StatelessWidget {
  const EnvironmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, AppEnvironment?>(
      selector: (state) => state.systemInfo?.environment,
      builder: (context, state) {
        return _EnvironmentCard(env: state);
      },
    );
  }
}

class _EnvironmentCard extends StatelessWidget {
  final AppEnvironment? env;

  const _EnvironmentCard({
    required this.env,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: const Text('Environment'),
      children: [
        ValueText(name: const Text('Env'), value: Text(env?.type.name.capitalize() ?? '-')),
        ValueText(name: const Text('GatewayUrl'), value: Text(env?.type.gateway.toString() ?? '-')),
        ValueText(name: const Text('ReviewsUrl'), value: Text(env?.type.reviews.toString() ?? '-')),
      ],
    );
  }
}
