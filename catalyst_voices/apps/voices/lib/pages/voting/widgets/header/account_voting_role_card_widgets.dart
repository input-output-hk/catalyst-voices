import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/menu/voices_raw_popup_menu_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

const double _cardHeight = 132;

class AccountVotingRoleCardDecoration extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final Widget child;

  const AccountVotingRoleCardDecoration({
    super.key,
    this.padding,
    this.color,
    this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: color,
        gradient: gradient,
      ),
      child: child,
    );
  }
}

class AccountVotingRoleInfoButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onTap;

  const AccountVotingRoleInfoButton({
    super.key,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: VoicesAssets.icons.informationCircle.buildIcon(
        color: color ?? Theme.of(context).colors.iconsPrimary,
      ),
    );
  }
}

class AccountVotingRoleInfoCard extends StatelessWidget {
  final EdgeInsets padding;
  final Widget label;
  final Widget value;
  final Widget infoButton;

  const AccountVotingRoleInfoCard({
    super.key,
    this.padding = const EdgeInsets.fromLTRB(24, 12, 8, 18),
    required this.label,
    required this.value,
    required this.infoButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AccountVotingRoleCardDecoration(
      padding: padding,
      color: theme.colors.elevationsOnSurfaceNeutralLv1White,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextStyle(
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colors.textOnPrimaryLevel0,
                ),
                child: label,
              ),
              infoButton,
            ],
          ),
          DefaultTextStyle(
            style: theme.textTheme.displayMedium!.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
            child: value,
          ),
        ],
      ),
    );
  }
}

class AccountVotingRolePopupInfoButton extends StatelessWidget {
  final Color? color;
  final WidgetBuilder menuBuilder;

  const AccountVotingRolePopupInfoButton({
    super.key,
    this.color,
    required this.menuBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesRawPopupMenuButton(
      buttonBuilder: (context, onTapCallback, {required isMenuOpen}) {
        return VoicesIconButton(
          onTap: onTapCallback,
          child: VoicesAssets.icons.informationCircle.buildIcon(
            color: color ?? Theme.of(context).colors.iconsPrimary,
          ),
        );
      },
      menuBuilder: menuBuilder,
      onSelected: (_) {},
      routeSettings: const RouteSettings(name: '/voting/voting-role/info-popup'),
    );
  }
}
