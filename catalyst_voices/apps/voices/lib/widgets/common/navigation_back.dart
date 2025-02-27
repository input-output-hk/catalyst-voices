import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBack extends StatelessWidget {
  final String? label;
  final EdgeInsetsGeometry padding;

  const NavigationBack({
    super.key,
    this.label,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          VoicesTextButton(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                GoRouter.of(context).go(Routes.initialLocation);
              }
            },
            leading: VoicesAssets.icons.arrowLeft.buildIcon(size: 18),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.textOnPrimaryLevel1,
              iconColor: context.colors.textOnPrimaryLevel1,
            ),
            child: Text(label ?? context.l10n.back),
          ),
        ],
      ),
    );
  }
}
