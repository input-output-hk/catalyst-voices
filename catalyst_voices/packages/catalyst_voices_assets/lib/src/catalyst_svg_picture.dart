import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// [CatalystSvgPicture] is a wrapper around [SvgPicture.asset] that sets the
/// package property to `catalyst_voices_assets` by default.
/// This allows to use the asset without having to specify the package name
/// every time.
/// For more information, see [SvgPicture.asset].
final class CatalystSvgPicture {
  static SvgPicture asset(
    String name, {
    AssetBundle? bundle,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    bool matchTextDirection = false,
    String package = 'catalyst_voices_assets',
    bool allowDrawingOutsideViewBox = false,
    Widget Function(BuildContext)? placeholderBuilder,
    Clip clipBehavior = Clip.hardEdge,
    SvgTheme? theme,
    ColorFilter? colorFilter,
  }) {
    return SvgPicture.asset(
      name,
      bundle: bundle,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      package: package,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      clipBehavior: clipBehavior,
      theme: theme,
      colorFilter: colorFilter,
    );
  }
}
