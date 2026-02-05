import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedVoicesCountdownTheme extends InheritedTheme {
  final AnimatedVoicesCountdownThemeData data;

  const AnimatedVoicesCountdownTheme({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(AnimatedVoicesCountdownTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AnimatedVoicesCountdownTheme(data: data, child: child);
  }

  static AnimatedVoicesCountdownThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AnimatedVoicesCountdownTheme>()?.data;
  }

  static AnimatedVoicesCountdownThemeData of(BuildContext context) {
    final data = maybeOf(context);
    assert(
      data != null,
      'Could not find AnimatedVoicesCountdownTheme in widget tree',
    );
    return data!;
  }
}

class AnimatedVoicesCountdownThemeData extends Equatable {
  final Color borderColor;
  final Color? backgroundColorLight;
  final Color? backgroundColorDark;
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double blurSigmaX;
  final double blurSigmaY;
  final double unitTextBottomPosition;
  final TextStyle? unitTextStyle;
  final VoicesDigitThemeData digitThemeData;

  const AnimatedVoicesCountdownThemeData({
    required this.borderColor,
    this.backgroundColorLight,
    this.backgroundColorDark,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.margin,
    required this.padding,
    required this.blurSigmaX,
    required this.blurSigmaY,
    required this.unitTextBottomPosition,
    this.unitTextStyle,
    required this.digitThemeData,
  });

  factory AnimatedVoicesCountdownThemeData.defaultTheme(BuildContext context) =>
      _AnimatedVoicesCountdownThemeDefault(context);

  factory AnimatedVoicesCountdownThemeData.primary(BuildContext context) =>
      _AnimatedVoicesCountdownThemePrimary(context);

  @override
  List<Object?> get props => [
    borderColor,
    backgroundColorLight,
    backgroundColorDark,
    width,
    height,
    borderRadius,
    margin,
    padding,
    blurSigmaX,
    blurSigmaY,
    unitTextBottomPosition,
    unitTextStyle,
    digitThemeData,
  ];

  Color? backgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? backgroundColorLight : backgroundColorDark;
  }
}

class VoicesDigitThemeData extends Equatable {
  final TextStyle? digitTextStyle;
  final double digitHeight;
  final double digitWidth;
  final double fallDistance;
  final double offset;

  const VoicesDigitThemeData({
    this.digitTextStyle,
    required this.digitHeight,
    required this.digitWidth,
    required this.fallDistance,
    required this.offset,
  });

  @override
  List<Object?> get props => [
    digitTextStyle,
    digitHeight,
    digitWidth,
    fallDistance,
    offset,
  ];
}

class _AnimatedVoicesCountdownThemeDefault extends AnimatedVoicesCountdownThemeData {
  _AnimatedVoicesCountdownThemeDefault(BuildContext context)
    : super(
        borderColor: Theme.of(context).colors.outlineBorder,
        width: 115,
        height: 134,
        borderRadius: 24,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        blurSigmaX: 0,
        blurSigmaY: 0,
        digitThemeData: VoicesDigitThemeData(
          digitHeight: 124,
          digitWidth: 37,
          fallDistance: 86,
          offset: 10,
          digitTextStyle: GoogleFonts.robotoMono(
            fontSize: 62,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colors.iconsForeground,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        unitTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.03,
          height: 1,
          color: Theme.of(context).colors.textOnPrimaryLevel1,
        ),
        unitTextBottomPosition: 20,
      );
}

class _AnimatedVoicesCountdownThemePrimary extends AnimatedVoicesCountdownThemeData {
  _AnimatedVoicesCountdownThemePrimary(BuildContext context)
    : super(
        borderColor: Theme.of(context).colors.outlineBorder,
        backgroundColorLight: Colors.white.withValues(alpha: 0.2),
        backgroundColorDark: Colors.black.withValues(alpha: 0.2),
        width: 144,
        height: 167,
        borderRadius: 16,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        blurSigmaX: 30,
        blurSigmaY: 30,
        digitThemeData: VoicesDigitThemeData(
          digitHeight: 160,
          digitWidth: 45,
          fallDistance: 100,
          offset: 20,
          digitTextStyle: GoogleFonts.robotoMono(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        unitTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.03,
          height: 1,
          color: Theme.of(context).colors.textOnPrimaryLevel1,
        ),
        unitTextBottomPosition: 35,
      );
}
