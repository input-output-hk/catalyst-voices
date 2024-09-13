import 'package:catalyst_voices/widgets/common/proposal_status_container.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesDrawerNavItem extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String name;
  final ProposalStatus status;

  const VoicesDrawerNavItem({
    super.key,
    this.leading,
    this.trailing,
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

    final iconTheme = IconThemeData(
      size: 24,
      color: theme.colors.iconsForeground,
    );

    return IconTheme(
      data: iconTheme,
      child: IconButtonTheme(
        data: IconButtonThemeData(style: iconButtonStyle),
        child: Container(
          constraints: BoxConstraints(minHeight: 56),
          padding: EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) leading!,
              Expanded(
                child: Text(
                  name,
                  style: nameTextStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ProposalStatusContainer(type: status),
              if (trailing != null) trailing!,
            ].separatedBy(SizedBox(width: 12)).toList(),
          ),
        ),
      ),
    );
  }
}
