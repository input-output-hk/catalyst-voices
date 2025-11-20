import 'package:catalyst_voices_shared/src/platform/form_factor/helpers/stub_form_factor.dart'
    if (dart.library.io) 'helpers/io_form_factor.dart'
    if (dart.library.js_interop) 'helpers/web_form_factor.dart';

/// A form factor of the device the app is executing on.
///
/// For flutter web it will attempt to differentiate whether the user is
/// running a browser on a mobile or desktop device and this enum will reflect that.
enum CatalystFormFactor {
  /// The app executes on a mobile-like device.
  mobile,

  /// The app executes on a desktop-like device.
  desktop;

  /// The breakpoint below which a screen is considered "mobile".
  static const double mobileScreenSizeBreakpoint = 640;

  /// The form factor the application is running on currently.
  static CatalystFormFactor get current {
    return isMobileFormFactor ? CatalystFormFactor.mobile : CatalystFormFactor.desktop;
  }

  bool get isDesktop => this == CatalystFormFactor.desktop;

  bool get isMobile => this == CatalystFormFactor.mobile;
}
