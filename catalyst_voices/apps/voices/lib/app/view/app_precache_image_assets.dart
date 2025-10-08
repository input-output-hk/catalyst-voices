import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

final _logger = Logger('AppPrecacheImageAssets');

class GlobalPrecacheImages extends StatefulWidget {
  final Widget child;

  const GlobalPrecacheImages({super.key, required this.child});

  @override
  State<GlobalPrecacheImages> createState() => _GlobalPrecacheImagesState();
}

class ImagePrecacheService {
  static final ImagePrecacheService _instance = ImagePrecacheService._();

  static ImagePrecacheService get instance => _instance;
  var _isInitialized = Completer<bool>();

  final Set<SvgGenImage> _svgs = {};
  final Set<AssetGenImage> _assets = {};

  final _lock = Lock();

  Brightness? _lastThemeMode;

  ImagePrecacheService._();

  Future<bool> get isInitialized => _isInitialized.future;

  Future<void> precacheAssets(
    BuildContext context, {
    List<SvgGenImage> svgs = const [],
    List<AssetGenImage> assets = const [],
  }) {
    final profiler = Dependencies.instance.get<CatalystStartupProfiler>();
    if (!profiler.ongoing) {
      return _precacheAssets(context, svgs: svgs, assets: assets);
    }

    return profiler.imagesCache(
      body: () => _precacheAssets(context, svgs: svgs, assets: assets),
    );
  }

  void resetCacheIfNeeded(ThemeData theme) {
    if (_lastThemeMode != theme.brightness) {
      // Handle case when caching is in progress and someone awaits completion.
      // For such case we're completing _isInitialized early.
      if (!_isInitialized.isCompleted && _lock.inLock) _isInitialized.complete(false);

      _isInitialized = Completer<bool>();
      _lastThemeMode = theme.brightness;
    }
  }

  Future<void> _cacheImageAsset(AssetGenImage asset, BuildContext context) async {
    try {
      await asset.cache(context: context);
    } catch (error) {
      _logger.info('Failed to cache image asset: $error');
    }
  }

  Future<void> _cacheSvgAsset(SvgGenImage svg, BuildContext context) async {
    try {
      await svg.cache(context: context);
    } catch (error) {
      _logger.info('Failed to cache SVG asset: $error');
    }
  }

  Future<void> _precacheAssets(
    BuildContext context, {
    List<SvgGenImage> svgs = const [],
    List<AssetGenImage> assets = const [],
  }) {
    return _lock.synchronized<void>(() async {
      if (_isInitialized.isCompleted) return;

      _svgs.addAll(svgs);
      _assets.addAll(assets);

      await Future.wait([
        ..._svgs.map((e) => _cacheSvgAsset(e, context)),
        ..._assets.map((e) => _cacheImageAsset(e, context)),
      ]);

      if (!_isInitialized.isCompleted) _isInitialized.complete(true);
    });
  }
}

class _GlobalPrecacheImagesState extends State<GlobalPrecacheImages> {
  Future<void>? _precacheFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _precacheFuture,
      builder: (context, snapshot) {
        final offstage = snapshot.connectionState != ConnectionState.done;

        if (offstage) {
          return const Offstage();
        }

        return widget.child;
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _precacheFuture ??= Future.microtask(() async => _precacheImages());
  }

  Future<void> _precacheImages() {
    final theme = Theme.of(context);

    ImagePrecacheService.instance.resetCacheIfNeeded(theme);

    return ImagePrecacheService.instance.precacheAssets(
      context,
      svgs: [
        theme.brandAssets.brand.logo(context),
        theme.brandAssets.brand.logoIcon(context),
      ],
      assets: [
        VoicesAssets.images.bgBubbles,
      ],
    );
  }
}
