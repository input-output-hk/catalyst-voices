import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountPageHeader extends StatelessWidget {
  const AccountPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: 350),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CatalystImage.asset(VoicesAssets.images.accountBg.path).image,
          fit: BoxFit.cover,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: _BackArrowButton(),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: _TitleText(),
          ),
          SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: _SubtitleText(),
          ),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.myAccountProfileKeychain,
      style: theme.textTheme.displayMedium?.copyWith(color: Colors.white),
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.yourCatalystKeychainAndRoleRegistration,
      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
    );
  }
}

class _BackArrowButton extends StatelessWidget {
  const _BackArrowButton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    final backgroundColor = colors.elevationsOnSurfaceNeutralLv1White;
    final foregroundColor = colors.iconsForeground;
    return VoicesIconButton.filled(
      onTap: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          GoRouter.of(context).go(Routes.initialLocation);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        foregroundColor: WidgetStateProperty.all(foregroundColor),
      ),
      child: VoicesAssets.icons.arrowNarrowLeft.buildIcon(),
    );
  }
}
