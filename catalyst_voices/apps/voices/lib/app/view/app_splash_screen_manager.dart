import 'dart:async';

import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/bubble_campaign_phase_aware_background.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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

  @override
  Widget build(BuildContext context) {
    if (!_areDocumentsSynced) {
      return _InAppLoading(message: context.l10n.loadingSyncingDocuments);
    }

    if (!_areImagesAndVideosCached) {
      return _InAppLoading(message: context.l10n.loadingAssets);
    }

    return widget.child;
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
  }

  Future<void> _handleDocumentsSync() async {
    final syncManager = Dependencies.instance.get<SyncManager>();
    final isSynced = await syncManager.isSynchronization;

    setState(() {
      _areDocumentsSynced = isSynced;
    });
  }

  Future<void> _handleImageAndVideoPrecache() async {
    final imagePrecacheService = ImagePrecacheService.instance;
    final videoPrecacheService = Dependencies.instance.get<VideoManager>();

    final isInitialized = await Future.wait([
      imagePrecacheService.isInitialized,
      videoPrecacheService.isInitialized,
    ]);

    setState(() {
      _areImagesAndVideosCached = isInitialized.every((e) => e);
    });
  }
}

class _InAppLoading extends StatelessWidget {
  final String message;

  const _InAppLoading({
    required this.message,
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
                VoicesAssets.lottie.voicesLoader.buildLottie(
                  width: 300,
                  height: 300,
                  repeat: true,
                  fit: BoxFit.contain,
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
