import 'package:catalyst_voices_driver/catalyst_voices_driver.dart';

extension VoicesWebDriverExt on VoicesWebDriver {
  /// Switches the WebDriver's focus to a window whose URL contains the specified pattern.
  ///
  /// [urlPattern] - The string pattern to match against window URLs.
  ///
  /// Returns a [Future<bool>] that completes with:
  /// - `true` if a matching window was found and switched to
  /// - `false` if no matching window was found
  Future<bool> switchToWindow(String urlPattern) async {
    final windows = await webDriver.windows.toList();
    for (final window in windows) {
      await webDriver.switchTo.window(window);
      final url = await webDriver.currentUrl;
      if (url.contains(urlPattern)) {
        return true;
      }
    }
    return false;
  }
}
