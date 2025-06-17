import 'package:catalyst_voices/pages/dev_tools/cards/info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/documents_count_text.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/sync_stats_text.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/value_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DocumentsCard extends StatelessWidget {
  const DocumentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoCard(
      title: Text('Documents'),
      children: [
        ValueText(name: Text('Sync stats'), value: SyncStatsText()),
        ValueText(name: Text('Documents count'), value: DocumentsCountText()),
        Row(
          spacing: 8,
          children: [
            _StartSyncButton(),
            _ClearButton(),
          ],
        ),
      ],
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      child: const Text('Clear'),
      onTap: () => context.read<DevToolsBloc>().add(const ClearDocumentsEvent()),
    );
  }
}

class _StartSyncButton extends StatelessWidget {
  const _StartSyncButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      child: const Text('Sync Now'),
      onTap: () => context.read<DevToolsBloc>().add(const SyncDocumentsEvent()),
    );
  }
}
