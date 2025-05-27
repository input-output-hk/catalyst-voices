import 'package:catalyst_voices/pages/dev_tools/widgets/info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/logs_collect_toggle.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/logs_export_button.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/logs_level_selector.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';

class LogsCard extends StatelessWidget {
  const LogsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, bool>(
      selector: (state) => state.areLogsOptionsAvailable,
      builder: (context, state) => _LogsCard(isAvailable: state),
    );
  }
}

class _LogsCard extends StatelessWidget {
  final bool isAvailable;

  const _LogsCard({
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: const Text('Logs'),
      children: [
        if (isAvailable) ...[
          const LogsLevelSelector(),
          const LogsCollectToggle(),
          const LogsExportButton(),
        ] else ...[
          const Text('Not Available'),
        ],
      ],
    );
  }
}
