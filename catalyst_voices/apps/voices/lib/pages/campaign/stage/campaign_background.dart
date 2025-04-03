import 'dart:math';

import 'package:catalyst_voices/widgets/painter/bubble_painter.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class CampaignBackground extends StatelessWidget {
  final Widget child;

  const CampaignBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const _Background(),
          const _BubbleShapes(),
          const _Logo(),
          child,
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEAF5FF),
            Color(0xFFCDDDFD),
          ],
        ),
      ),
    );
  }
}

class _BubbleShapes extends StatelessWidget {
  const _BubbleShapes();

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
        position: (size) => Offset(0 - 110, size.height * .45),
        radius: 224,
        gradientColors: [
          Color.fromARGB(
            (255 * 0.5).toInt(),
            18,
            60,
            211,
          ),
        ],
        gradientStops: const [1],
      ),
      BubbleConfig(
        position: (size) => Offset(size.width * .7, -220),
        radius: 372,
        gradientColors: const [Color(0x9FC01CEB)],
        gradientStops: const [0],
      ),
      BubbleConfig(
        position: (size) => Offset(size.width * .92, size.height * .85),
        radius: 140,
        gradientColors: const [Color(0xFFE5F6FF)],
        gradientStops: const [0],
        shadowBlur: 250,
        shadowOffset: const Offset(-40, -44),
        shadowColor: const Color.fromRGBO(
          150,
          142,
          253,
          0.4,
        ),
      ),
    ];
  }

  List<ShapeConfig> _buildShapes() {
    return [
      ShapeConfig(
        controlPointsCalculator: (Size size) => [
          Point(size.width * .8, 0),
          Point(size.width * .7, size.height * .25),
          Point(size.width, size.height * .5),
          Point(size.width, 0),
        ],
        gradient: const RadialGradient(
          center: Alignment(0.8321, 0.2873),
          radius: 0.7135,
          colors: [
            Color(0xAFC6C5FF),
            Color(0xBFDCD5FE),
          ],
          stops: [0.0, 1.0],
        ),
      ),
    ];
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 60,
      top: 40,
      child: Theme.of(context).brandAssets.brand.logo(context).buildPicture(
            height: 35,
          ),
    );
  }
}
