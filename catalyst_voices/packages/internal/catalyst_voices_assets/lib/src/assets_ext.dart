import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show svg;
import 'package:lottie/lottie.dart' as lottie;
import 'package:vector_graphics/vector_graphics.dart';

extension AssetGenImageExt on AssetGenImage {
  /// Returns an [ImageProvider] with the package automatically set
  /// to 'catalyst_voices_assets'.
  ImageProvider voicesProvider({AssetBundle? bundle}) {
    return provider(
      bundle: bundle,
      package: 'catalyst_voices_assets',
    );
  }

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

extension AssetsIconsGenExt on $AssetsIconsGen {
  /// Returns the [SvgGenImage] by the asset [name].
  SvgGenImage getIcon(String name) {
    return SvgGenImage('assets/icons/$name.svg');
  }
}

extension LottieGenImageExt on LottieGenImage {
  /// Builds a lottie animation widget.
  Widget buildLottie({
    Animation<double>? controller,
    bool? animate,
    lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    lottie.LottieDelegates? delegates,
    lottie.LottieOptions? options,
    void Function(lottie.LottieComposition)? onLoaded,
    lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, lottie.LottieComposition?)? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package = 'catalyst_voices_assets',
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    lottie.LottieDecoder? decoder,
    lottie.RenderCache? renderCache,
    bool? backgroundLoading,
  }) {
    return this.lottie(
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
      decoder: decoder,
      renderCache: renderCache,
      backgroundLoading: backgroundLoading,
    );
  }
}

extension SvgGenImageExt on SvgGenImage {
  /// See [CatalystSvgIcon]. See class for more context.
  Widget buildIcon({
    Key? key,
    AssetBundle? bundle,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    double? size,
    bool allowSize = true,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    bool matchTextDirection = false,
    String package = 'catalyst_voices_assets',
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Clip clipBehavior = Clip.hardEdge,
    Color? color,
    ColorFilter? colorFilter,
    bool allowColorFilter = true,
  }) {
    assert(
      color == null || colorFilter == null,
      'Either color or colorFilter is supported but not both',
    );

    return CatalystSvgIcon.asset(
      path,
      key: key,
      bundle: bundle,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      size: size,
      allowSize: allowSize,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      package: package,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      clipBehavior: clipBehavior,
      color: color,
      colorFilter: colorFilter,
      allowColorFilter: allowColorFilter,
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
    Color? color,
    ColorFilter? colorFilter,
  }) {
    assert(
      color == null || colorFilter == null,
      'Either color or colorFilter is supported but not both',
    );

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
      colorFilter:
          colorFilter ??
          (color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null),
    );
  }

  /// Pre caching this svg if not already cached.
  Future<ByteData> cache({
    BuildContext? context,
    String package = 'catalyst_voices_assets',
    AssetBundle? bundle,
  }) {
    final loader = AssetBytesLoader(
      path,
      packageName: package,
      assetBundle: bundle,
    );
    return svg.cache.putIfAbsent(
      loader.cacheKey(context),
      () => loader.loadBytes(context),
    );
  }
}
