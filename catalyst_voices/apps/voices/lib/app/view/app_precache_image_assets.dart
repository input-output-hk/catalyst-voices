import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalPrecacheImages extends StatelessWidget {
  final Widget child;

  const GlobalPrecacheImages({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPrecacheImageAssets(
      svgs: [
        theme.brandAssets.brand.logo(context),
        theme.brandAssets.brand.logoIcon(context),
      ],
      assets: [
        VoicesAssets.images.comingSoonBkg,
      ],
      child: child,
    );
  }
}

/// A widget that pre-caches SVG and image assets before displaying its
/// child widget.
///
/// This widget is useful for improving the perceived performance of your
/// app by pre-loading any necessary image assets before they are displayed on
/// the screen.
/// This can help to avoid stuttering or delays when the user navigates to a
/// new screen that requires those images.
///
/// [AppPrecacheImageAssets] depends on [Theme] and is trying to make
/// as little work as possible when [Theme] is changing by caching
/// previously loaded assets.
class AppPrecacheImageAssets extends StatefulWidget {
  /// List of [SvgGenImage] which should be cached.
  final List<SvgGenImage> svgs;

  /// List of [AssetGenImage] which should be cached.
  final List<AssetGenImage> assets;

  /// The child widget to be displayed once the images have been pre-cached.
  final Widget child;

  const AppPrecacheImageAssets({
    super.key,
    this.svgs = const [],
    this.assets = const [],
    required this.child,
  });

  @override
  State<AppPrecacheImageAssets> createState() => _AppPrecacheImageAssetsState();
}

class _AppPrecacheImageAssetsState extends State<AppPrecacheImageAssets> {
  final _svgs = <SvgGenImage>[];
  final _assets = <AssetGenImage>[];

  bool _hadImages = false;

  late Future<void> _cacheFuture;

  @override
  void didUpdateWidget(AppPrecacheImageAssets oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_areImagesDifferent()) {
      _updateImagesCache();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Caching depends on context. Rebuild when changes.
    _updateImagesCache();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _cacheFuture,
      builder: (context, snapshot) {
        return switch (snapshot.connectionState) {
          // Only blocking when does did not have images eg. First run.
          // Do not block when theme mode is changing because it will
          // cause blinking.
          ConnectionState.active ||
          ConnectionState.waiting when !_hadImages =>
            const _ProgressIndicator(),
          ConnectionState.none ||
          ConnectionState.waiting ||
          ConnectionState.active ||
          ConnectionState.done =>
            widget.child,
        };
      },
    );
  }

  void _updateImagesCache() {
    _hadImages = _svgs.isNotEmpty || _assets.isNotEmpty;

    _svgs
      ..clear()
      ..addAll(widget.svgs);
    _assets
      ..clear()
      ..addAll(widget.assets);

    // ignore: discarded_futures
    _cacheFuture = _buildCacheFuture(svgs: _svgs, assets: _assets);
  }

  bool _areImagesDifferent() {
    final old = [
      ..._svgs.map((e) => e.path),
      ..._assets.map((e) => e.path),
    ];
    final current = [
      ...widget.svgs.map((e) => e.path),
      ...widget.assets.map((e) => e.path),
    ];

    return !listEquals(old, current);
  }

  Future<void> _buildCacheFuture({
    List<SvgGenImage> svgs = const [],
    List<AssetGenImage> assets = const [],
  }) {
    final futures = <Future<void>>[
      ...svgs.map((e) => e.cache(context: context)),
      ...assets.map((e) => e.cache(context: context)),
    ];

    return Future.wait(futures);
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(child: VoicesCircularProgressIndicator());
  }
}
