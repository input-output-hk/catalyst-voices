import 'dart:async';

import 'package:catalyst_voices/pages/dev_tools/dev_tools_page.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppGlobalShortcuts extends StatelessWidget {
  static final devToolsShortcut = LogicalKeySet(
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.keyD,
  );

  final Widget child;

  const AppGlobalShortcuts({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDeveloper = context.select<DevToolsBloc, bool>((value) => value.state.isDeveloper);

    // TODO(damian-molinski): migrate AdminTools shortcut here from SpacesShellPage.
    return CallbackShortcuts(
      bindings: {
        if (isDeveloper)
          devToolsShortcut: () {
            final routerContext = AppRouter.rootNavigatorKey.currentContext;
            if (routerContext != null) {
              unawaited(DevToolsPage.show(routerContext));
            }
          },
      },
      child: child,
    );
  }
}
