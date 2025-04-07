import 'dart:math';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/painter/bubble_painter.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

typedef _LayoutData = ({
  TextStyle? titleStyle,
  TextStyle? subtitleStyle,
  TextStyle? descriptionStyle,
  bool isMobile,
});

class AppMobileAccessRestriction extends StatelessWidget {
  final Widget child;

  const AppMobileAccessRestriction({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformAwareBuilder<Widget>(
      mobileWeb: ResponsiveBuilder<_LayoutData>(
        xs: (
          titleStyle: context.textTheme.displayMedium?.copyWith(
            color: context.colorScheme.primary,
          ),
          subtitleStyle: context.textTheme.titleSmall,
          descriptionStyle: context.textTheme.bodyMedium,
          isMobile: true,
        ),
        other: (
          titleStyle: context.textTheme.displayMedium?.copyWith(
            color: context.colorScheme.primary,
            fontSize: 78,
            height: 1.15,
          ),
          subtitleStyle: context.textTheme.titleMedium,
          descriptionStyle: context.textTheme.bodyLarge,
          isMobile: false,
        ),
        builder: (context, data) => _MobileSplashScreen(
          data: data,
        ),
      ),
      other: child,
      builder: (context, child) => child!,
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 52),
          VoicesFilledButton(
            child: Text(context.l10n.joinNewsletter),
            onTap: () {
              // TODO(LynxLynxx): implement url launching
            },
          ),
          const SizedBox(height: 12),
          VoicesTextButton(
            child: Text(context.l10n.visitGitbook),
            onTap: () {
              // TODO(LynxLynxx): implement url launching
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final bool isMobile;

  const _Background({
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        bubbles: _buildBubbles(),
        shapes: _buildShapes(),
      ),
      size: Size.infinite,
    );
  }

  List<BubbleConfig> _buildBubbles() {
    return [
      BubbleConfig(
        position: (size) => Offset(
          isMobile ? 0 - 70 : 0 - 90,
          size.height * 0.25,
        ),
        radius: isMobile ? 110 : 200,
        gradientColors: const [Color(0xFFE5F6FF), Color(0xCCE5F6FF)],
        gradientStops: const [0.0, 1.0],
        shadowBlur: 62.46,
        shadowOffset: const Offset(-9.99, -10.99),
        shadowColor: const Color.fromRGBO(150, 142, 253, 0.4),
      ),
      BubbleConfig(
        position: (size) => Offset(
          isMobile ? size.width + 70 : size.width + 140,
          isMobile ? size.height : size.height + 140,
        ),
        radius: isMobile ? 140 : 430,
        gradientColors: const [Color(0xFFE5F6FF), Color(0xCCE5F6FF)],
        gradientStops: const [0.0, 1.0],
        shadowBlur: 62.46,
        shadowOffset: const Offset(-9.99, -10.99),
        shadowColor: const Color.fromRGBO(150, 142, 253, 0.4),
      ),
    ];
  }

  List<ShapeConfig> _buildShapes() {
    return [
      ShapeConfig(
        controlPointsCalculator: (Size size) => [
          Point(0, size.height * .7),
          Point(size.width * .13, size.height * .82),
          Point(size.width * .15, size.height),
          Point(0, size.height),
        ],
        gradient: const RadialGradient(
          center: Alignment(0.2822, -0.3306),
          radius: 0.5,
          colors: [Color(0x99F9E7FD), Color(0x99F6CEFF)],
          stops: [1.0, 0.0],
        ),
      ),
      ShapeConfig(
        controlPointsCalculator: (Size size) => [
          Point(size.width * .75, 0),
          Point(
            isMobile ? size.width * .8 : size.width * .7,
            isMobile ? size.height * .15 : size.height * .3,
          ),
          Point(
            size.width,
            isMobile ? size.height * .25 : size.height * .4,
          ),
          Point(size.width, 0),
        ],
        color: Color.fromARGB((255 * 0.1).toInt(), 192, 20, 235),
      ),
      ShapeConfig(
        controlPointsCalculator: (Size size) => [
          Point(size.width, size.height * .2),
          Point(size.width * .7, size.height * .45),
          Point(size.width, size.height * .6),
        ],
        gradient: const RadialGradient(
          center: Alignment(0.2814, -0.3306),
          radius: 0.5,
          colors: [
            Color.fromRGBO(205, 213, 254, 0.7),
            Color(0x99C6C5FF),
          ],
          stops: [0.0, 1.0],
        ),
      ),
    ];
  }
}

class _Foreground extends StatelessWidget {
  final _LayoutData data;

  const _Foreground({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Theme.of(context)
                .brandAssets
                .brand
                .logo(context)
                .buildPicture(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: data.isMobile ? 400 : 620,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CatalystImage.asset(
                      VoicesAssets.images.mobileRestrictAccess.path,
                      height: data.isMobile ? 203 : 400,
                    ),
                    Text(
                      context.l10n.mobileAccessTitle,
                      style: data.titleStyle,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.mobileAccessSubtitle,
                      style: data.subtitleStyle,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.mobileAccessDescription,
                      style: data.descriptionStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const _Actions(),
        ],
      ),
    );
  }
}

class _MobileSplashScreen extends StatelessWidget {
  final _LayoutData data;

  const _MobileSplashScreen({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _Background(isMobile: data.isMobile),
        _Foreground(data: data),
      ],
    );
  }
}
