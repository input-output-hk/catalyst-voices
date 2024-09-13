import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'
    show SvgTheme, svg, SvgAssetLoader, ColorMapper;

extension SvgGenImageExt on SvgGenImage {
  /// Pre caching this svg if not already cached.
  Future<ByteData> cache({
    BuildContext? context,
    String package = 'catalyst_voices_assets',
    AssetBundle? bundle,
    ColorMapper? colorMapper,
  }) {
    final loader = SvgAssetLoader(
      path,
      packageName: package,
      assetBundle: bundle,
      colorMapper: colorMapper,
    );
    return svg.cache.putIfAbsent(
      loader.cacheKey(context),
      () => loader.loadBytes(context),
    );
  }

  /// Builds [CatalystSvgPicture]. See class for more context.
  Widget buildPicture({
    Key? key,
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
    WidgetBuilder? placeholderBuilder,
    Clip clipBehavior = Clip.hardEdge,
    SvgTheme? theme,
    ColorFilter? colorFilter,
  }) {
    return CatalystSvgPicture.asset(
      path,
      key: key,
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

  /// See [CatalystSvgIcon]. See class for more context.
  Widget buildIcon({
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
    bool allowColorFilter = true,
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
      allowColorFilter: allowColorFilter,
    );
  }
}

extension AssetGenImageExt on AssetGenImage {
  Future<void> cache({
    required BuildContext context,
    AssetBundle? bundle,
    String package = 'catalyst_voices_assets',
    Size? size,
    ImageErrorListener? onError,
  }) {
    final loader = AssetImage(
      path,
      bundle: bundle,
      package: package,
    );

    return precacheImage(
      loader,
      context,
      size: size,
      onError: onError,
    );
  }
}
