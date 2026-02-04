import 'dart:math';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
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

/// At the moment we're supporting only desktops. This widget replaces app content with
/// placeholder on not supported devices.
class AppMobileAccessRestriction extends StatelessWidget {
  final RouterConfig<Object> routerConfig;
  final Widget child;

  const AppMobileAccessRestriction({
    super.key,
    required this.routerConfig,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final provider = routerConfig.routeInformationProvider!;

    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        final isProposalRoute = ProposalRoute.isPath(provider.value.uri);

        return FormFactorBuilder<bool>(
          mobile: CatalystPlatform.isWeb && !isProposalRoute,
          desktop: false,
          builder: (context, isRestricted) => isRestricted ? const _MobileWebPlaceholder() : child,
        );
      },
    );
  }
}

class _Actions extends StatelessWidget with LaunchUrlMixin {
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
            onTap: () async {
              await launchUri(VoicesConstants.joinNewsletterUrl.getUri());
            },
          ),
          const SizedBox(height: 12),
          VoicesTextButton(
            child: Text(context.l10n.visitGitbook),
            onTap: () async {
              await launchUri(VoicesConstants.mobileExperienceUrl.getUri());
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final bool isSmallScreen;

  const _Background({
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        bubbles: _buildBubbles(),
        shapes: _buildShapes(),
        backgroundColor: const Color(0xFF9BDDF7),
      ),
      size: Size.infinite,
    );
  }

  List<BubbleConfig> _buildBubbles() {
    return [
      BubbleConfig(
        position: (size) => Offset(
          isSmallScreen ? 0 - 70 : 0 - 90,
          size.height * 0.25,
        ),
        radius: isSmallScreen ? 110 : 200,
        gradientColors: const [Color(0xFFE5F6FF), Color(0xCCE5F6FF)],
        gradientStops: const [0.0, 1.0],
        shadowBlur: 62.46,
        shadowOffset: const Offset(-9.99, -10.99),
        shadowColor: const Color.fromRGBO(150, 142, 253, 0.4),
      ),
      BubbleConfig(
        position: (size) => Offset(
          isSmallScreen ? size.width + 70 : size.width + 140,
          isSmallScreen ? size.height : size.height + 140,
        ),
        radius: isSmallScreen ? 140 : 430,
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
          colors: [Color(0x99F9E7FD), Color(0x99F6CEFF)],
          stops: [1.0, 0.0],
        ),
      ),
      ShapeConfig(
        controlPointsCalculator: (Size size) => [
          Point(size.width * .75, 0),
          Point(
            isSmallScreen ? size.width * .8 : size.width * .7,
            isSmallScreen ? size.height * .15 : size.height * .3,
          ),
          Point(
            size.width,
            isSmallScreen ? size.height * .25 : size.height * .4,
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
            child: Theme.of(context).brandAssets.brand.logo(context).buildPicture(),
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
        _Background(isSmallScreen: data.isMobile),
        _Foreground(data: data),
      ],
    );
  }
}

class _MobileWebPlaceholder extends StatelessWidget {
  const _MobileWebPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<_LayoutData>(
      xs: (
        titleStyle: context.textTheme.displayMedium?.copyWith(
          color: context.colorScheme.primary,
        ),
        subtitleStyle: context.textTheme.titleSmall,
        descriptionStyle: context.textTheme.bodyMedium,
        isMobile: true,
      ),
      sm: (
        titleStyle: context.textTheme.displayMedium?.copyWith(
          color: context.colorScheme.primary,
          fontSize: 78,
          height: 1.15,
        ),
        subtitleStyle: context.textTheme.titleMedium,
        descriptionStyle: context.textTheme.bodyLarge,
        isMobile: false,
      ),
      builder: (context, data) => _MobileSplashScreen(data: data),
    );
  }
}
