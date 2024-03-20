import 'package:catalyst_voices_shared/src/platform/catalyst_platform.dart';
import 'package:flutter/widgets.dart';

class PlatformAwareBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T? data) builder;
  final T? android;
  final T? desktop;
  final T? fuchsia;
  final T? iOS;
  final T? linux;
  final T? macOS;
  final T? mobile;
  final T? mobileWeb;
  final T? web;
  final T? webDesktop;
  final T? windows;
  final T? other;

  const PlatformAwareBuilder({
    super.key,
    required this.builder,
    this.android,
    this.desktop,
    this.fuchsia,
    this.iOS,
    this.linux,
    this.macOS,
    this.mobile,
    this.mobileWeb,
    this.web,
    this.webDesktop,
    this.windows,
    this.other,
  });

  @override
  Widget build(BuildContext context) {
    if (CatalystPlatform.isAndroid && android != null) {
      return builder(context, android as T);
    } else if (CatalystPlatform.isDesktop && desktop != null) {
      return builder(context, desktop as T);
    } else if (CatalystPlatform.isFuchsia && fuchsia != null) {
      return builder(context, fuchsia as T);
    } else if (CatalystPlatform.isIOS && iOS != null) {
      return builder(context, iOS as T);
    } else if (CatalystPlatform.isLinux && linux != null) {
      return builder(context, linux as T);
    } else if (CatalystPlatform.isMacOS && macOS != null) {
      return builder(context, linux as T);
    } else if (CatalystPlatform.isMobile && mobile != null) {
      return builder(context, mobile as T);
    } else if (CatalystPlatform.isMobileWeb && mobileWeb != null) {
      return builder(context, mobileWeb as T);
    } else if (CatalystPlatform.isWeb && web != null) {
      return builder(context, web as T);
    } else if (CatalystPlatform.isWebDesktop && webDesktop != null) {
      return builder(context, webDesktop as T);
    } else if (CatalystPlatform.isWindows && windows != null) {
      return builder(context, windows as T);
    } else if (other != null) {
      return builder(context, other as T);
    } else {
      return builder(context, null);
    }
  }
}
