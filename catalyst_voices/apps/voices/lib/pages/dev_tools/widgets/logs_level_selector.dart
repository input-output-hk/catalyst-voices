import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

const _allLevels = [
  Level.ALL,
  Level.OFF,
  Level.FINEST,
  Level.FINER,
  Level.FINE,
  Level.CONFIG,
  Level.INFO,
  Level.WARNING,
  Level.SEVERE,
  Level.SHOUT,
];

class LogsLevelSelector extends StatelessWidget {
  const LogsLevelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, Level?>(
      selector: (state) => state.logsLevel,
      builder: (context, state) => _LogsLevelSelector(current: state),
    );
  }
}

class _LogsLevelSelector extends StatelessWidget {
  final Level? current;

  const _LogsLevelSelector({
    this.current,
  });

  @override
  Widget build(BuildContext context) {
    return FilterByDropdown<Level>(
      items: _allLevels.map((level) => DropdownMenuEntry(value: level, label: level.name)).toList(),
      onChanged: (value) => context.read<DevToolsBloc>().add(ChangeLogLevelEvent(value)),
      value: current,
    );
  }
}
