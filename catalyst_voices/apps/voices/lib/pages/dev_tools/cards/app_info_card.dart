import 'package:catalyst_voices/pages/dev_tools/cards/info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/build_mode_text.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/build_number_text.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/value_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, AppInfo?>(
      selector: (state) => state.systemInfo?.app,
      builder: (context, state) {
        return _AppInfoCard(
          version: state?.version,
          buildNumber: state?.buildNumber,
        );
      },
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  final String? version;
  final String? buildNumber;

  const _AppInfoCard({
    this.version,
    this.buildNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: const Text('App Info'),
      children: [
        ValueText(name: const Text('Version'), value: Text(version ?? '')),
        ValueText(name: const Text('BuildNumber'), value: BuildNumberText(buildNumber)),
        const ValueText(name: Text('BuildMode'), value: BuildModeText()),
      ],
    );
  }
}
