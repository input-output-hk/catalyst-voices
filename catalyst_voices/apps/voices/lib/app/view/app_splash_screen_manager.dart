import 'dart:async';

import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:flutter/widgets.dart';

/// Hides the splash screen as soon as it initializes.
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
  late final Timer _timer;

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // hide splash screen after a delay to give the UI chance
    // to render so that there's no white space for a split second
    _timer = Timer(
      const Duration(milliseconds: 100),
      hideSplashScreen,
    );
  }
}
