import 'package:catalyst_voices/pages/dev_tools/widgets/info_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class GatewayInfoCard extends StatelessWidget {
  const GatewayInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, GatewayInfo?>(
      selector: (state) => state.systemInfo?.gateway,
      builder: (context, state) => const _GatewayInfoCard(),
    );
  }
}

class _GatewayInfoCard extends StatelessWidget {
  const _GatewayInfoCard();

  @override
  Widget build(BuildContext context) {
    return const InfoCard(
      title: Text('Gateway Info'),
      children: [],
    );
  }
}
