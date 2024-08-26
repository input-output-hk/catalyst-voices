/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $InternalResourcesGen {
  const $InternalResourcesGen();

  /// Directory path: internal_resources/icons
  $InternalResourcesIconsGen get icons => const $InternalResourcesIconsGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/catalyst_logo.svg
  SvgGenImage get catalystLogo =>
      const SvgGenImage('assets/images/catalyst_logo.svg');

  /// File path: assets/images/catalyst_logo_icon.svg
  SvgGenImage get catalystLogoIcon =>
      const SvgGenImage('assets/images/catalyst_logo_icon.svg');

  /// File path: assets/images/catalyst_logo_icon_white.svg
  SvgGenImage get catalystLogoIconWhite =>
      const SvgGenImage('assets/images/catalyst_logo_icon_white.svg');

  /// File path: assets/images/catalyst_logo_white.svg
  SvgGenImage get catalystLogoWhite =>
      const SvgGenImage('assets/images/catalyst_logo_white.svg');

  /// File path: assets/images/coming_soon_bkg.webp
  AssetGenImage get comingSoonBkg =>
      const AssetGenImage('assets/images/coming_soon_bkg.webp');

  /// File path: assets/images/dragger.svg
  SvgGenImage get dragger => const SvgGenImage('assets/images/dragger.svg');

  /// File path: assets/images/dummy_catalyst_voices.webp
  AssetGenImage get dummyCatalystVoices =>
      const AssetGenImage('assets/images/dummy_catalyst_voices.webp');

  /// File path: assets/images/fallback_logo.svg
  SvgGenImage get fallbackLogo =>
      const SvgGenImage('assets/images/fallback_logo.svg');

  /// File path: assets/images/fallback_logo_icon.svg
  SvgGenImage get fallbackLogoIcon =>
      const SvgGenImage('assets/images/fallback_logo_icon.svg');

  /// List of all assets
  List<dynamic> get values => [
        catalystLogo,
        catalystLogoIcon,
        catalystLogoIconWhite,
        catalystLogoWhite,
        comingSoonBkg,
        dragger,
        dummyCatalystVoices,
        fallbackLogo,
        fallbackLogoIcon
      ];
}

class $InternalResourcesIconsGen {
  const $InternalResourcesIconsGen();

  /// File path: internal_resources/icons/.gitkeep
  String get aGitkeep => 'internal_resources/icons/.gitkeep';

  /// File path: internal_resources/icons/facebook.svg
  SvgGenImage get facebook =>
      const SvgGenImage('internal_resources/icons/facebook.svg');

  /// File path: internal_resources/icons/facebook_mono.svg
  SvgGenImage get facebookMono =>
      const SvgGenImage('internal_resources/icons/facebook_mono.svg');

  /// File path: internal_resources/icons/linkedin.svg
  SvgGenImage get linkedin =>
      const SvgGenImage('internal_resources/icons/linkedin.svg');

  /// File path: internal_resources/icons/linkedin_mono.svg
  SvgGenImage get linkedinMono =>
      const SvgGenImage('internal_resources/icons/linkedin_mono.svg');

  /// File path: internal_resources/icons/x.svg
  SvgGenImage get x => const SvgGenImage('internal_resources/icons/x.svg');

  /// File path: internal_resources/icons/x_mono.svg
  SvgGenImage get xMono =>
      const SvgGenImage('internal_resources/icons/x_mono.svg');

  /// List of all assets
  List<dynamic> get values =>
      [aGitkeep, facebook, facebookMono, linkedin, linkedinMono, x, xMono];
}

class VoicesAssets {
  VoicesAssets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $InternalResourcesGen internalResources =
      $InternalResourcesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final BytesLoader loader;
    if (_isVecFormat) {
      loader = AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
