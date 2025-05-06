import 'dart:math';

import 'package:catalyst_voices/routes/routing/root_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// 404 not found page.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: _Background(),
        ),
        Positioned.fill(
          left: 24,
          right: 24,
          child: Column(
            children: [
              Spacer(flex: 3),
              _Image(),
              SizedBox(height: 56),
              _Title(),
              SizedBox(height: 12),
              _Message(),
              SizedBox(height: 32),
              _Button(),
              Spacer(flex: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return CatalystImage.asset(
      VoicesAssets.images.bgBubbles.path,
      fit: BoxFit.fill,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      leading: VoicesAssets.icons.arrowNarrowRight.buildIcon(),
      child: Text(context.l10n.notFoundButton),
      onTap: () => const RootRoute().go(context),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final minImageWidth = min(300, screenWidth * 0.9);
    const maxImageWidth = 500;
    final preferredImageWidth = screenWidth * 0.6;

    final imageWidth = preferredImageWidth.clamp(
      minImageWidth,
      maxImageWidth,
    );

    return Center(
      child: CatalystImage.asset(
        VoicesAssets.images.notFound404.path,
        width: imageWidth.toDouble(),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      context.l10n.notFoundMessage,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge
          ?.copyWith(color: theme.colors.textOnPrimaryLevel1),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      context.l10n.notFoundTitle,
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineLarge
          ?.copyWith(color: theme.colorScheme.primary),
    );
  }
}
