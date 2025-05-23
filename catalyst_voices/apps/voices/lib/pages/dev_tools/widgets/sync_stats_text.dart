import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SyncStatsText extends StatelessWidget {
  const SyncStatsText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, SyncStats?>(
      selector: (state) => state.syncStats,
      builder: (context, state) => _SyncStatsText(state ?? const SyncStats()),
    );
  }
}

class _SyncStatsText extends StatelessWidget {
  final SyncStats data;

  const _SyncStatsText(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'lastSuccessfulSyncAt -> ${data.lastSuccessfulSyncAt?.toUtc().toIso8601String() ?? '-'}',
        ),
        Text('lastAddedRefsCount -> ${data.lastAddedRefsCount ?? '-'}'),
        Text('lastSyncDuration -> ${data.lastSyncDuration ?? '-'}'),
      ],
    );
  }
}
