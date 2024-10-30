import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackFab extends StatelessWidget {
  const BackFab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colors.iconsBackground,
      child: VoicesAssets.icons.arrowLeft.buildIcon(),
      onPressed: () {
        final goRouter = GoRouter.of(context);

        if (goRouter.canPop()) {
          goRouter.pop();
        } else {
          // TODO(damian-molinski): should go to initial route later
          // goRouter.go(Routes.initialLocation);
          const TreasuryRoute().go(context);
        }
      },
    );
  }
}
