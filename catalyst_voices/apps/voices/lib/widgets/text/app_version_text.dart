import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class AppVersionText extends StatelessWidget {
  final Color color;

  const AppVersionText({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, AppInfo?>(
      selector: (state) {
        return state.appInfo;
      },
      builder: (context, appInfo) {
        if (appInfo == null) {
          return const Offstage();
        }
        return Text(
          context.l10n.appVersion(appInfo.version, appInfo.buildNumber),
          style: context.textTheme.bodyMedium?.copyWith(color: color),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
