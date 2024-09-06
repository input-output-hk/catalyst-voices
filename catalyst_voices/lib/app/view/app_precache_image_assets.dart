import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  /// The child widget to be displayed once the images have been pre-cached.
  final Widget child;

  const AppPrecacheImageAssets({
    super.key,
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = Theme.of(context);

    final svgs = [
      theme.brandAssets.logo,
      theme.brandAssets.logoIcon,
    ];

    final assets = [
      VoicesAssets.images.comingSoonBkg,
    ];

    final paths = [
      ...svgs.map((e) => e.path),
      ...assets.map((e) => e.path),
    ];
    final currentPaths = [
      ..._svgs.map((e) => e.path),
      ..._assets.map((e) => e.path),
    ];

    if (!listEquals(paths, currentPaths)) {
      _hadImages = _svgs.isNotEmpty || _assets.isNotEmpty;

      _svgs
        ..clear()
        ..addAll(svgs);
      _assets
        ..clear()
        ..addAll(assets);

      final futures = <Future<void>>[
        ...svgs.map((e) => e.cache(context: context)),
        ...assets.map((e) => e.cache(context: context)),
      ];

      _cacheFuture = Future.wait(futures);
    }
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
            _ProgressIndicator(),
          ConnectionState.none ||
          ConnectionState.waiting ||
          ConnectionState.active ||
          ConnectionState.done =>
            widget.child,
        };
      },
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(child: VoicesCircularProgressIndicator());
  }
}
