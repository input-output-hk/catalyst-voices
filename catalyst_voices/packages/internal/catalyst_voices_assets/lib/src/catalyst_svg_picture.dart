import 'package:flutter_svg/flutter_svg.dart';

/// [CatalystSvgPicture] extends [SvgPicture] to have an asset constructor
/// tat sets the package property to `catalyst_voices_assets` by default.
/// This allows to use the asset without having to specify the package name
/// every time.
/// For more information, see [SvgPicture.asset].
final class CatalystSvgPicture extends SvgPicture {
  const CatalystSvgPicture(
    super.bytesLoader, {
    super.key,
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.matchTextDirection,
    super.allowDrawingOutsideViewBox,
    super.placeholderBuilder,
    super.colorFilter,
    super.semanticsLabel,
    super.excludeFromSemantics,
    super.clipBehavior,
  }) : super();

  CatalystSvgPicture.asset(
    super.name, {
    super.key,
    super.matchTextDirection,
    super.bundle,
    super.package = 'catalyst_voices_assets',
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.allowDrawingOutsideViewBox,
    super.placeholderBuilder,
    super.semanticsLabel,
    super.excludeFromSemantics,
    super.clipBehavior,
    super.theme,
    super.colorFilter,
  }) : super.asset();
}
