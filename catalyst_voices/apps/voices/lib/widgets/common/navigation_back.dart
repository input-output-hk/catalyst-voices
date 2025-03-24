import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBack extends StatelessWidget {
  final String? label;
  final bool isCompact;

  const NavigationBack({
    super.key,
    this.label,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      key: const Key('NavigationBackBtn'),
      onTap: () => _popRoute(context),
      leading: isCompact ? null : VoicesAssets.icons.arrowLeft.buildIcon(),
      style: TextButton.styleFrom(
        foregroundColor: context.colors.textOnPrimaryLevel1,
        iconColor: context.colors.textOnPrimaryLevel1,
        iconSize: isCompact ? 24 : 18,
        shape: isCompact ? const CircleBorder() : null,
      ),
      child: isCompact
          ? VoicesAssets.icons.arrowLeft.buildIcon()
          : Text(label ?? context.l10n.back),
    );
  }

  void _popRoute(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      GoRouter.of(context).go(Routes.initialLocation);
    }
  }
}
