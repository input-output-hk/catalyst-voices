import 'package:catalyst_voices_assets/src/catalyst_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Builds an svg icon using [SvgPicture] via [CatalystSvgPicture] but on
/// top of that extracts configuration from [IconTheme] like
/// [IconThemeData.size] or [IconThemeData.color] and applies those if not
/// specified directly in [size] or [colorFilter].
class CatalystSvgIcon extends StatelessWidget {
  /// See [SvgPicture.width] and [SvgPicture.height]
  final double? size;

  /// See [SvgPicture.fit]
  final BoxFit fit;

  /// See [SvgPicture.alignment]
  final AlignmentGeometry alignment;

  /// See [SvgPicture.bytesLoader]
  final BytesLoader bytesLoader;

  /// See [SvgPicture.placeholderBuilder]
  final WidgetBuilder? placeholderBuilder;

  /// See [SvgPicture.matchTextDirection]
  final bool matchTextDirection;

  /// See [SvgPicture.allowDrawingOutsideViewBox]
  final bool allowDrawingOutsideViewBox;

  /// See [SvgPicture.semanticsLabel]
  final String? semanticsLabel;

  /// See [SvgPicture.excludeFromSemantics]
  final bool excludeFromSemantics;

  /// See [SvgPicture.clipBehavior]
  final Clip clipBehavior;

  /// See [SvgPicture.colorFilter]
  final ColorFilter? colorFilter;

  /// Whether to use [colorFilter] or not. Some icons don't need that
  final bool allowColorFilter;

  const CatalystSvgIcon(
    this.bytesLoader, {
    super.key,
    this.size,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.colorFilter,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.allowColorFilter = true,
  });

  CatalystSvgIcon.asset(
    String assetName, {
    super.key,
    AssetBundle? bundle,
    String? package = 'catalyst_voices_assets',
    SvgTheme? theme,
    this.size,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.colorFilter,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.allowColorFilter = true,
  }) : bytesLoader = SvgAssetLoader(
          assetName,
          packageName: package,
          assetBundle: bundle,
          theme: theme,
        );

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? IconTheme.of(context).size;
    final effectiveColorFilter = allowColorFilter
        ? colorFilter ?? IconTheme.of(context).asColorFilter()
        : null;

    return CatalystSvgPicture(
      bytesLoader,
      width: effectiveSize,
      height: effectiveSize,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      colorFilter: effectiveColorFilter,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
    );
  }
}

extension _IconThemeDataExt on IconThemeData {
  ColorFilter? asColorFilter() {
    final color = this.color;
    return color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null;
  }
}
