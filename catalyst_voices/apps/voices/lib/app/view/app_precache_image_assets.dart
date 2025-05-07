import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AssetsPrecacheService {
  static final AssetsPrecacheService _instance = AssetsPrecacheService._();

  static AssetsPrecacheService get instance => _instance;
  bool _isInitialized = false;

  final Set<SvgGenImage> _svgs = {};
  final Set<AssetGenImage> _assets = {};
  final Map<String, VideoPlayerController> _videoControllers = {};

  Brightness? _lastThemeMode;
  AssetsPrecacheService._();

  bool get isInitialized => _isInitialized;

  VideoPlayerController? getVideoController(String asset) =>
      _videoControllers[asset];

  Future<void> precacheAssets(
    BuildContext context, {
    List<SvgGenImage> svgs = const [],
    List<AssetGenImage> assets = const [],
    List<String> videoAssets = const [],
    String? videoPackage,
  }) async {
    if (_isInitialized) return;

    _svgs.addAll(svgs);
    _assets.addAll(assets);

    await Future.wait([
      ..._svgs.map((e) => e.cache(context: context)),
      ..._assets.map((e) => e.cache(context: context)),
      ...videoAssets.map((asset) async {
        final controller =
            VideoPlayerController.asset(asset, package: videoPackage);
        await controller.initialize();
        await controller.setLooping(true);
        await controller.setVolume(0);
        _videoControllers[asset] = controller;
      }),
    ]);

    _isInitialized = true;
  }

  Future<void> resetCacheIfNeeded(ThemeData theme) async {
    if (_lastThemeMode != theme.brightness) {
      _isInitialized = false;
      _lastThemeMode = theme.brightness;

      for (final controller in _videoControllers.values) {
        await controller.dispose();
      }
      _videoControllers.clear();
    }
  }
}

class GlobalPrecacheAssets extends StatefulWidget {
  final Widget child;

  const GlobalPrecacheAssets({super.key, required this.child});

  @override
  State<GlobalPrecacheAssets> createState() => _GlobalPrecacheImagesState();
}

class _GlobalPrecacheImagesState extends State<GlobalPrecacheAssets> {
  Future<void>? _precacheFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _precacheFuture,
      builder: (context, snapshot) {
        final offstage = snapshot.connectionState == ConnectionState.waiting &&
            !AssetsPrecacheService.instance.isInitialized;

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

    AssetsPrecacheService.instance.resetCacheIfNeeded(theme);

    return AssetsPrecacheService.instance.precacheAssets(
      context,
      svgs: [
        theme.brandAssets.brand.logo(context),
        theme.brandAssets.brand.logoIcon(context),
      ],
      assets: [
        VoicesAssets.images.bgBubbles,
      ],
      videoAssets: [
        VoicesAssets.videos.heroDesktop,
      ],
      videoPackage: 'catalyst_voices_assets',
    );
  }
}
