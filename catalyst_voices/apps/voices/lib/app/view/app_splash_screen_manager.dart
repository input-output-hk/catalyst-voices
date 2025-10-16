import 'dart:async';

import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/bubble_campaign_phase_aware_background.dart';
import 'package:catalyst_voices/widgets/indicators/voices_loading_indicator.dart';
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

class _AppSplashScreenManagerState extends State<AppSplashScreenManager>
    with SingleTickerProviderStateMixin {
  bool _areDocumentsSynced = false;
  bool _areImagesAndVideosCached = false;
  bool _messageShownEnoughTime = true;
  bool _fontsAreReady = false;

  bool get _isReady =>
      _areDocumentsSynced && _areImagesAndVideosCached && _messageShownEnoughTime && _fontsAreReady;

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return widget.child;
    }

    return _InAppLoading(
      key: const Key('AppLoadingScreen'),
      message: context.l10n.settingThingsAppInSplashScreen,
      messageShownEnoughTime: _handleMessageShownEnoughTime,
    );
  }

  @override
  void initState() {
    super.initState();

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
    final syncManager = Dependencies.instance.get<SyncManager>();
    final campaignPhaseAwareCubit = context.read<CampaignPhaseAwareCubit>();

    await syncManager.waitForSync;
    await campaignPhaseAwareCubit.awaitForInitialize;

    if (mounted) {
      setState(() {
        _areDocumentsSynced = true;
        _finishStartupProfilerIfReady();
      });
    }
  }

  Future<void> _handleFonts() async {
    final profiler = Dependencies.instance.get<CatalystStartupProfiler>();
    try {
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

  void _handleMessageShownEnoughTime(bool value) {
    if (mounted) {
      setState(() {
        _messageShownEnoughTime = value;
        _finishStartupProfilerIfReady();
      });
    }
  }
}

class _InAppLoading extends StatefulWidget {
  final String message;
  final ValueChanged<bool> messageShownEnoughTime;

  const _InAppLoading({
    super.key,
    required this.message,
    required this.messageShownEnoughTime,
  });

  @override
  State<_InAppLoading> createState() => _InAppLoadingState();
}

class _InAppLoadingState extends State<_InAppLoading> {
  bool _showMessage = false;
  Timer? _messageTimer;
  Timer? _minimumLoadingTimer;

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
                AnimatedOpacity(
                  opacity: _showMessage ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _messageTimer = null;

    _minimumLoadingTimer?.cancel();
    _minimumLoadingTimer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _messageTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showMessage = true;
        });

        _minimumLoadingTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            widget.messageShownEnoughTime(true);
          }
        });
      }
    });
  }
}
