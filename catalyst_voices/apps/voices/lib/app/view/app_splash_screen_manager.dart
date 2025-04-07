import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:flutter/widgets.dart';

/// Hides the splash screen after a frame is drawn when the widget initializes.
class AppSplashScreenManager extends StatefulWidget {
  final Widget child;

  const AppSplashScreenManager({
    super.key,
    required this.child,
  });

  @override
  State<AppSplashScreenManager> createState() => _AppSplashScreenManagerState();
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
        hideSplashScreen();
      }
    });
  }
}
