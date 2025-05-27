import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';

class LogsCollectToggle extends StatelessWidget {
  const LogsCollectToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, bool>(
      selector: (state) => state.collectLogs,
      builder: (context, state) => _LogsCollectToggle(isEnabled: state),
    );
  }
}

class _LogsCollectToggle extends StatelessWidget {
  final bool isEnabled;

  const _LogsCollectToggle({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return AffixDecorator(
      prefix: const Text('Collect logs'),
      child: VoicesSwitch(
        value: isEnabled,
        onChanged: (value) {
          context.read<DevToolsBloc>().add(ChangeCollectLogsEvent(isEnabled: value));
        },
      ),
    );
  }
}
