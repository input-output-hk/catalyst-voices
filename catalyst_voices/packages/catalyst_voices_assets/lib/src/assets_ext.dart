import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_assets/src/catalyst_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgTheme;

extension SvgGenImageExt on SvgGenImage {
  Widget build({
    Key? key,
    AssetBundle? bundle,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    double? size,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    bool matchTextDirection = false,
    String package = 'catalyst_voices_assets',
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Clip clipBehavior = Clip.hardEdge,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    bool useColorFilter = true,
  }) {
    return CatalystSvgIcon.asset(
      path,
      key: key,
      bundle: bundle,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      size: size,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      package: package,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      clipBehavior: clipBehavior,
      theme: theme,
      colorFilter: colorFilter,
      useColorFilter: useColorFilter,
    );
  }
}
