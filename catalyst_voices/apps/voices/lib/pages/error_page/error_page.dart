import 'dart:math';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A fullscreen error page. Meant to be used as a template for other error pages.
class ErrorPage extends StatelessWidget {
  final AssetGenImage image;
  final double maxImageWidth;
  final String title;
  final String message;
  final Widget button;

  const ErrorPage({
    super.key,
    required this.image,
    this.maxImageWidth = 500,
    required this.title,
    required this.message,
    required this.button,
  });

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
              Center(
                child: _Image(
                  image: image,
                  maxImageWidth: maxImageWidth,
                ),
              ),
              const SizedBox(height: 56),
              _Title(text: title),
              const SizedBox(height: 12),
              _Message(text: message),
              const SizedBox(height: 32),
              button,
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

class _Image extends StatelessWidget {
  final AssetGenImage image;
  final double maxImageWidth;

  const _Image({
    required this.image,
    required this.maxImageWidth,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final minImageWidth = min(300, screenWidth * 0.9);
    final preferredImageWidth = screenWidth * 0.6;

    final imageWidth = preferredImageWidth.clamp(
      minImageWidth,
      maxImageWidth,
    );

    return CatalystImage.asset(
      image.path,
      width: imageWidth.toDouble(),
      fit: BoxFit.cover,
    );
  }
}

class _Message extends StatelessWidget {
  final String text;

  const _Message({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colors.textOnPrimaryLevel1),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.primary),
    );
  }
}
