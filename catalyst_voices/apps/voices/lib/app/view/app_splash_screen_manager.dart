import 'dart:async';

import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/bubble_campaign_phase_aware_background.dart';
import 'package:catalyst_voices/widgets/indicators/voices_linear_progress_indicator.dart';
import 'package:catalyst_voices/widgets/indicators/voices_loading_indicator.dart';
import 'package:catalyst_voices/widgets/indicators/voices_progress_indicator_weight.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';

final _logger = Logger('AppSplashScreenManager');

/// Hides the splash screen after a frame is drawn when the widget initializes.
class AppSplashScreenManager extends StatefulWidget {
  final Widget child;

  const AppSplashScreenManager({
    super.key,
    required this.child,
  });

  @override
  State<AppSplashScreenManager> createState() => _AppSplashScreenManagerState();

  /// Hides the splash screen.
  ///
  /// https://pub.dev/packages/flutter_native_splash#3-set-up-app-initialization-optional
  static void hideSplashScreen() {
    FlutterNativeSplash.remove();
  }

  /// Flutter by default removes the splash screen when it draws the first
  /// frame, we'd like to preserve it until we've loaded the content.
  ///
  /// https://pub.dev/packages/flutter_native_splash#3-set-up-app-initialization-optional
  static void preserveSplashScreen(WidgetsBinding widgetsBinding) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
}

class _AnimatedProgressSection extends StatelessWidget {
  final String message;
  final double progress;
  final bool showProgressBar;

  const _AnimatedProgressSection({
    required this.message,
    required this.progress,
    required this.showProgressBar,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showProgressBar ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 360,
            child: AnimatedVoicesLinearProgressIndicator(
              value: progress,
              animationDuration: const Duration(milliseconds: 800),
              animationCurve: Curves.easeInOutCubic,
              weight: VoicesProgressIndicatorWeight.heavy,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppSplashScreenManagerState extends State<AppSplashScreenManager>
    with SingleTickerProviderStateMixin {
  bool _areDocumentsSynced = false;
  bool _areImagesAndVideosCached = false;
  bool _messageShownEnoughTime = true;
  bool _fontsAreReady = false;

  final Stopwatch _loadingStopwatch = Stopwatch();
  bool _showProgressIndicator = false;
  Timer? _minimumVisibilityTimer;

  late final SyncManager _syncManager;

  bool get _isReady =>
      _areDocumentsSynced && _areImagesAndVideosCached && _messageShownEnoughTime && _fontsAreReady;

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return widget.child;
    }

    // Throttle progress updates to reduce rebuilds
    final throttledStream = _syncManager.progressStream.distinct((prev, curr) {
      if (prev <= 0 || curr >= 1.0) return false;

      return (curr - prev).abs() < 0.008; // ~0.8% minimum change
    });

    return StreamBuilder<double>(
      stream: throttledStream,
      initialData: 0,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0;
        final shouldShow = _handleProgressBarVisibility(progress);

        return _InAppLoading(
          key: const Key('AppLoadingScreen'),
          message: context.l10n.settingThingsAppInSplashScreen,
          progress: progress,
          showProgressBar: shouldShow,
        );
      },
    );
  }

  @override
  void dispose() {
    _minimumVisibilityTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _syncManager = Dependencies.instance.get<SyncManager>();
    _loadingStopwatch.start();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppSplashScreenManager.hideSplashScreen();
      }
    });

    unawaited(_handleDocumentsSync());
    unawaited(_handleImageAndVideoPrecache());
    unawaited(_handleFonts());
  }

  void _finishStartupProfilerIfReady() {
    if (!_isReady) {
      return;
    }

    final profiler = Dependencies.instance.get<CatalystStartupProfiler>();
    if (!profiler.ongoing) {
      return;
    }

    profiler.finish();
  }

  Future<void> _handleDocumentsSync() async {
    final campaignPhaseAwareCubit = context.read<CampaignPhaseAwareCubit>();

    await _syncManager.waitForSync;
    await campaignPhaseAwareCubit.awaitForInitialize;

    if (mounted) {
      setState(() {
        _areDocumentsSynced = true;
        _finishStartupProfilerIfReady();
      });
    }
  }

  Future<void> _handleFonts() async {
    try {
      final profiler = Dependencies.instance.get<CatalystStartupProfiler>();
      await profiler.awaitingFonts(body: () async => GoogleFonts.pendingFonts());
    } catch (error, stackTrace) {
      _logger.warning('Load pending google fonts', error, stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _fontsAreReady = true;
        });
      }
    }
  }

  Future<void> _handleImageAndVideoPrecache() async {
    final imagePrecacheService = ImagePrecacheService.instance;
    final videoPrecacheService = Dependencies.instance.get<VideoManager>();

    final isInitialized = await Future.wait([
      imagePrecacheService.isInitialized,
      videoPrecacheService.isInitialized,
    ]);

    if (mounted) {
      setState(() {
        _areImagesAndVideosCached = isInitialized.every((e) => e);
        _finishStartupProfilerIfReady();
      });
    }
  }

  bool _handleProgressBarVisibility(double progress) {
    final elapsed = _loadingStopwatch.elapsedMilliseconds;
    var showProgressBar = false;

    if (progress > 0 && progress < 1.0) {
      final estimatedTotal = elapsed / progress;
      final estimatedTimeRemaining = estimatedTotal - elapsed;
      showProgressBar = elapsed > 500 && estimatedTimeRemaining > 500;

      if (showProgressBar && !_showProgressIndicator) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_showProgressIndicator) {
            setState(() {
              _showProgressIndicator = true;
            });
            _startMinimumVisibilityTimer();
          }
        });
      }
    }

    return showProgressBar || _showProgressIndicator;
  }

  void _startMinimumVisibilityTimer() {
    _minimumVisibilityTimer?.cancel();

    // After 2 seconds, hide progress indicator and mark message as shown long enough
    _minimumVisibilityTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showProgressIndicator = false;
          _messageShownEnoughTime = true;
          _finishStartupProfilerIfReady();
        });
      }
    });
  }
}

class _InAppLoading extends StatelessWidget {
  final String message;
  final double progress;
  final bool showProgressBar;

  const _InAppLoading({
    super.key,
    required this.message,
    this.progress = 0,
    this.showProgressBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: BubbleCampaignPhaseAwareBackground(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 18),
                const VoicesLoadingIndicator(
                  key: Key('PersistentLoadingIndicator'),
                ),
                _AnimatedProgressSection(
                  message: message,
                  progress: progress,
                  showProgressBar: showProgressBar,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
