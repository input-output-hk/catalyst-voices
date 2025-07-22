import 'dart:math';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ErrorCampaignPhaseAware extends StatelessWidget {
  final LocalizedException error;

  const ErrorCampaignPhaseAware({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: _Background(),
        ),
        Positioned.fill(
          left: 24,
          right: 24,
          child: Column(
            children: [
              const Spacer(flex: 3),
              const _Image(),
              const SizedBox(height: 56),
              const _Title(),
              const SizedBox(height: 12),
              _Message(error: error),
              const SizedBox(height: 32),
              const _Button(),
              const Spacer(flex: 4),
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
      child: Text(context.l10n.retry),
      onTap: () async => context.read<CampaignPhaseAwareCubit>().getActiveCampaign(),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final minImageWidth = min(100, screenWidth * 0.9);
    const maxImageWidth = 200;
    final preferredImageWidth = screenWidth * 0.6;

    final imageWidth = preferredImageWidth.clamp(
      minImageWidth,
      maxImageWidth,
    );

    return Center(
      child: CatalystImage.asset(
        VoicesAssets.images.magGlass.path,
        width: imageWidth.toDouble(),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final LocalizedException error;

  const _Message({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      error.message(context),
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colors.textOnPrimaryLevel1),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      context.l10n.noActiveCampaignFound,
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.primary),
    );
  }
}
