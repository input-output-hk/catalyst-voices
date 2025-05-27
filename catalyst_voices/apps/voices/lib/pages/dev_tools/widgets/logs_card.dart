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
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: const _LogsCard(),
        );
      },
    );
  }
}

class _LogsCard extends StatelessWidget {
  const _LogsCard();

  @override
  Widget build(BuildContext context) {
    return const InfoCard(
      title: Text('Logs'),
      children: [
        LogsLevelSelector(),
        LogsCollectToggle(),
        LogsExportButton(),
      ],
    );
  }
}
