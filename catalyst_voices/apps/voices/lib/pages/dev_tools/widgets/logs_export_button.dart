import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';

class LogsExportButton extends StatelessWidget {
  const LogsExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, bool>(
      selector: (state) => state.collectLogs,
      builder: (context, state) => _LogsExportButton(isEnabled: state),
    );
  }
}

class _LogsExportButton extends StatelessWidget {
  final bool isEnabled;

  const _LogsExportButton({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: isEnabled
          ? () => context.read<DevToolsBloc>().add(const PrepareAndExportLogsEvent())
          : null,
      child: const Text('Export Logs'),
    );
  }
}
