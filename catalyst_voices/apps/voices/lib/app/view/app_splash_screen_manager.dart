import 'dart:async';

import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/bubble_campaign_phase_aware_background.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices/widgets/indicators/voices_linear_progress_indicator.dart';
import 'package:catalyst_voices/widgets/indicators/voices_loading_indicator.dart';
import 'package:catalyst_voices/widgets/indicators/voices_progress_indicator_weight.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
  bool _isWaitingForDocumentsSync = true;
  bool _areImagesAndVideosCached = false;
  bool _fontsAreReady = false;

  Timer? _progressDataTimerTicker;
  bool _showProgressIndicator = false;

  StreamSubscription<double>? _syncProgressSub;
  double _syncProgress = 0;

  final _loadingStopwatch = Stopwatch();

  bool get _isReady => !_isWaitingForDocumentsSync && _areImagesAndVideosCached && _fontsAreReady;

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return widget.child;
    }

    return _InAppLoading(
      key: const Key('AppLoadingScreen'),
      message: context.l10n.settingThingsAppInSplashScreen,
      progress: _syncProgress,
      showProgressBar: _showProgressIndicator,
    );
  }

  @override
  void dispose() {
    _progressDataTimerTicker?.cancel();
    _progressDataTimerTicker = null;

    unawaited(_syncProgressSub?.cancel());
    _syncProgressSub = null;

    if (_loadingStopwatch.isRunning) _loadingStopwatch.stop();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final syncManager = Dependencies.instance.get<SyncManager>();
    _setupSyncProgressStreams(syncManager);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppSplashScreenManager.hideSplashScreen();
      }
    });

    unawaited(_handleDocumentsSync(syncManager));
    unawaited(_handleImageAndVideoPrecache());
    unawaited(_handleFonts());
  }

  bool _calculateShowProgressIndicator(double progress, Duration elapsed) {
    if (progress == 0.0 || progress == 1.0) return false;

    final elapsedInMilliseconds = elapsed.inMilliseconds.toDouble();
    final estimatedTotal = elapsedInMilliseconds / progress;
    final estimatedTimeRemaining = estimatedTotal - elapsedInMilliseconds;
    return elapsedInMilliseconds > 500 && estimatedTimeRemaining > 500;
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

  /// Returns progress stream only for active sync request.
  Stream<double> _getSyncProgressStream(SyncManager syncManager) {
    final activeRequest = syncManager.activeRequest;
    if (activeRequest == null) {
      return Stream<double>.value(1);
    }

    return syncManager.activeRequestProgress;
  }

  Future<void> _handleDocumentsSync(SyncManager syncManager) async {
    final activeRequest = syncManager.activeRequest;
    final isInitialProposalRoute = ProposalRoute.isPath(initialLocation);

    if (activeRequest == null || (isInitialProposalRoute && activeRequest is! TargetSyncRequest)) {
      _isWaitingForDocumentsSync = false;
      return;
    }

    await syncManager.waitForActiveRequest;

    if (mounted) {
      setState(() {
        _isWaitingForDocumentsSync = false;
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

  void _handleSyncProgress(double value) {
    setState(() {
      _syncProgress = value;
      _showProgressIndicator = _calculateShowProgressIndicator(value, _loadingStopwatch.elapsed);
    });
  }

  void _setupSyncProgressStreams(SyncManager syncManager) {
    _syncProgressSub = _getSyncProgressStream(
      syncManager,
    ).distinct(_throttleSyncProgress).listen(_handleSyncProgress);

    _progressDataTimerTicker = Timer.periodic(
      const Duration(milliseconds: 250),
      _updateShowProgress,
    );

    _loadingStopwatch.start();
  }

  bool _throttleSyncProgress(double prev, double curr) {
    if (prev <= 0 || curr >= 1.0) return false;

    return (curr - prev).abs() < 0.008; // ~0.8% minimum change
  }

  void _updateShowProgress(Timer timer) {
    setState(() {
      final elapsed = _loadingStopwatch.elapsed;
      final progress = _syncProgress;
      _showProgressIndicator = _calculateShowProgressIndicator(progress, elapsed);
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
