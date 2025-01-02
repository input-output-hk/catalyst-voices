import 'package:catalyst_voices/widgets/common/proposal_status_container.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesNavTile extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String name;
  final ProposalStatus? status;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;

  const VoicesNavTile({
    super.key,
    this.leading,
    this.trailing,
    required this.name,
    this.status,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const iconButtonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
    );

    final nameTextStyle = theme.textTheme.labelLarge?.copyWith(
      color: foregroundColor ?? theme.colors.textPrimary,
    );

    final iconTheme = IconThemeData(
      size: 24,
      color: foregroundColor ?? theme.colors.iconsForeground,
    );

    return IconTheme(
      key: const ValueKey('UserDrawerMenuItem'),
      data: iconTheme,
      child: IconButtonTheme(
        data: const IconButtonThemeData(style: iconButtonStyle),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Material(
            type: backgroundColor != null
                ? MaterialType.canvas
                : MaterialType.transparency,
            shape: const StadiumBorder(),
            color: backgroundColor,
            child: InkWell(
              onTap: onTap,
              customBorder: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
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
                    if (status != null) ProposalStatusContainer(type: status!),
                    if (trailing != null) trailing!,
                  ].separatedBy(const SizedBox(width: 12)).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
