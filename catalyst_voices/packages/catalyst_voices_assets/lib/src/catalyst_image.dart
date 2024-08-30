import 'package:flutter/widgets.dart';

/// [CatalystImage] extends [Image] to have an asset constructor
/// tat sets the package property to `catalyst_voices_assets` by default.
/// This allows to use the asset without having to specify the package name
/// every time.
/// For more information, see [Image.asset].
final class CatalystImage extends Image {
  CatalystImage.asset(
    super.name, {
    super.key,
    super.bundle,
    super.frameBuilder,
    super.errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics,
    super.scale,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    Alignment super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.gaplessPlayback,
    super.isAntiAlias,
    String super.package = 'catalyst_voices_assets',
    super.filterQuality = FilterQuality.low,
    super.cacheWidth,
    super.cacheHeight,
  }) : super.asset();
}
