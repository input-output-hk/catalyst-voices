import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class GlobalPrecacheImages extends StatefulWidget {
  final Widget child;

  const GlobalPrecacheImages({super.key, required this.child});

  @override
  State<GlobalPrecacheImages> createState() => _GlobalPrecacheImagesState();
}

class ImagePrecacheService {
  static final ImagePrecacheService _instance = ImagePrecacheService._();

  static ImagePrecacheService get instance => _instance;
  bool _isInitialized = false;

  final Set<SvgGenImage> _svgs = {};
  final Set<AssetGenImage> _assets = {};

  Brightness? _lastThemeMode;
  ImagePrecacheService._();

  bool get isInitialized => _isInitialized;

  Future<void> precacheAssets(
    BuildContext context, {
    List<SvgGenImage> svgs = const [],
    List<AssetGenImage> assets = const [],
  }) async {
    if (_isInitialized) return;

    _svgs.addAll(svgs);
    _assets.addAll(assets);

    await Future.wait([
      ..._svgs.map((e) => e.cache(context: context)),
      ..._assets.map((e) => e.cache(context: context)),
    ]);

    _isInitialized = true;
  }

  void resetCacheIfNeeded(ThemeData theme) {
    if (_lastThemeMode != theme.brightness) {
      _isInitialized = false;
      _lastThemeMode = theme.brightness;
    }
  }
}

class _GlobalPrecacheImagesState extends State<GlobalPrecacheImages> {
  Future<void>? _precacheFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _precacheFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !ImagePrecacheService.instance.isInitialized) {
          return const Center(child: VoicesCircularProgressIndicator());
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
      assets: [VoicesAssets.images.comingSoonBkg],
    );
  }
}
