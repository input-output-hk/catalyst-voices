import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

typedef _LayoutData = ({
  AssetGenImage image,
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
          image: VoicesAssets.images.mobileAccess.mobileX2,
          titleStyle: context.textTheme.displayMedium?.copyWith(
            color: context.colorScheme.primary,
          ),
          subtitleStyle: context.textTheme.titleSmall,
          descriptionStyle: context.textTheme.bodyMedium,
          isMobile: true,
        ),
        other: (
          image: VoicesAssets.images.mobileAccess.mobileX2,
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
      other: _MobileSplashScreen(
        data: (
          image: VoicesAssets.images.mobileAccess.mobileX2,
          titleStyle: context.textTheme.displayMedium?.copyWith(
            color: context.colorScheme.primary,
            fontSize: 72,
            height: 1.15,
          ),
          subtitleStyle: context.textTheme.titleSmall,
          descriptionStyle: context.textTheme.bodyMedium,
          isMobile: false,
        ),
      ),
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
      painter: _BubblePainter(isMobile: isMobile),
      size: Size.infinite,
    );
  }
}

class _BubblePainter extends CustomPainter {
  final bool isMobile;

  _BubblePainter({required this.isMobile});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xff9BDDF7),
    );

    void drawBubble(
      double x,
      double y,
      double radius,
      List<Color> gradientColors,
      List<double> gradientStops,
    ) {
      final rect = Rect.fromCircle(center: Offset(x, y), radius: radius);

      final shadowPath = Path()..addOval(rect);

      canvas
        ..save()
        ..translate(-9.99, -10.99)
        ..drawShadow(
          shadowPath,
          const Color.fromRGBO(150, 142, 253, 0.4),
          62.46,
          true,
        )
        ..restore();

      final paintGradient = Paint()
        ..shader = RadialGradient(
          colors: gradientColors,
          stops: gradientStops,
          center: Alignment.center,
          radius: 0.8,
        ).createShader(rect)
        ..blendMode = BlendMode.softLight;

      canvas.drawCircle(Offset(x, y), radius, paintGradient);
    }

    //left bubble
    drawBubble(
      isMobile ? 0 - 70 : 0 - 90,
      size.height * 0.25,
      isMobile ? 110 : 200,
      [
        const Color(0xFFE5F6FF),
        const Color(0xCCE5F6FF),
      ],
      [0.0, 1.0],
    );
    //right bubble
    drawBubble(
      isMobile ? size.width + 70 : size.width + 140,
      isMobile ? size.height : size.height + 140,
      isMobile ? 140 : 430,
      [
        const Color(0xFFE5F6FF),
        const Color(0xCCE5F6FF),
      ],
      [0.0, 1.0],
    );

    //left shapes
    final leftPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.2822, -0.3306),
        radius: 0.5,
        colors: [
          Color(0x99F9E7FD),
          Color(0x99F6CEFF),
        ],
        stops: [0.0, 0.0],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final leftShapePath = Path()
      ..moveTo(0, size.height * .7)
      ..quadraticBezierTo(
        size.width * .13,
        size.height * .82,
        size.width * .15,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(leftShapePath, leftPaint);

    // right shapes
    final firstRightPath = Path()
      ..moveTo(size.width * .75, 0)
      ..quadraticBezierTo(
        isMobile ? size.width * .8 : size.width * .7,
        isMobile ? size.height * .15 : size.height * .3,
        size.width,
        isMobile ? size.height * .25 : size.height * .4,
      )
      ..lineTo(size.width, 0);
    final firstRightPaint = Paint()
      ..color = Color.fromARGB((255 * 0.1).toInt(), 192, 20, 235)
      ..style = PaintingStyle.fill;

    firstRightPath.close();

    canvas.drawPath(firstRightPath, firstRightPaint);

    final secondRightPath = Path()
      ..moveTo(size.width, size.height * .2)
      ..quadraticBezierTo(
        size.width * .7,
        size.height * .45,
        size.width,
        size.height * .6,
      )
      ..close();
    final secondRightPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.2814, -0.3306),
        radius: 0.5,
        colors: [
          Color.fromRGBO(205, 213, 254, 0.7),
          Color(0x99C6C5FF),
        ],
        stops: [0.0, 1.0],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(secondRightPath, secondRightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
            child: CatalystImage.asset(
              VoicesAssets.images.mobileAccess.catalystLogo.path,
              alignment: Alignment.centerLeft,
            ),
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
                      data.image.path,
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
