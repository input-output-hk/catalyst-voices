import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/common/proposal_status_container.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesDrawerNavItem extends StatelessWidget {
  final String name;
  final ProposalStatus status;

  const VoicesDrawerNavItem({
    super.key,
    required this.name,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconButtonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
    );

    final nameTextStyle = theme.textTheme.labelLarge?.copyWith(
      color: theme.colors.textPrimary,
    );

    return IconButtonTheme(
      data: IconButtonThemeData(style: iconButtonStyle),
      child: Container(
        constraints: BoxConstraints(minHeight: 56),
        padding: EdgeInsets.only(left: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                name,
                style: nameTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ProposalStatusContainer(type: status),
            VoicesIconButton(
              child: VoicesAssets.icons.dotsVertical.buildIcon(),
              onTap: () {},
            ),
          ].separatedBy(SizedBox(width: 12)).toList(),
        ),
      ),
    );
  }
}
