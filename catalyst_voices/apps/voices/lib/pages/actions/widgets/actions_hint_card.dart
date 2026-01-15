import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/action_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class ActionsHintCard extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final String description;
  final BoxConstraints? constraints;

  const ActionsHintCard({
    super.key,
    this.title,
    this.icon,
    required this.description,
    this.constraints,
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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ActionCard(
        icon: icon ?? VoicesAssets.icons.informationCircle.buildIcon(),
        iconBackgroundColor: context.colors.iconsSecondary,
        title: title != null ? Text(title!) : null,
        desc: Text(description),
      ),
    );
  }
}
