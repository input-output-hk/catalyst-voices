import 'package:flutter/widgets.dart';
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

  /// Flutter by default removes the splash screen when it draws the first frame,
  /// we'd like to preserve it until we've loaded the content.
  ///
  /// https://pub.dev/packages/flutter_native_splash#3-set-up-app-initialization-optional
  static void preserveSplashScreen(WidgetsBinding widgetsBinding) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
}

class _AppSplashScreenManagerState extends State<AppSplashScreenManager>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppSplashScreenManager.hideSplashScreen();
      }
    });
  }
}
