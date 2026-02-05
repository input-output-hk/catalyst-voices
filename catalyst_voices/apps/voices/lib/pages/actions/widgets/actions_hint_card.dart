import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/action_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class ActionsHintCard extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final Widget description;
  final BoxConstraints? constraints;
  final EdgeInsets iconPadding;
  final Color? iconBackgroundColor;

  const ActionsHintCard({
    super.key,
    this.title,
    this.icon,
    required this.description,
    this.constraints,
    this.iconPadding = const EdgeInsets.all(8),
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: context.colors.dropShadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ActionCard(
        icon: icon ?? VoicesAssets.icons.informationCircle.buildIcon(),
        iconBackgroundColor: iconBackgroundColor ?? context.colors.iconsSecondary,
        iconPadding: iconPadding,
        title: title != null ? Text(title!) : null,
        desc: description,
      ),
    );
  }
}
