import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// Validates if a given URL is an image URL
final class ImageUrlValidator {
  ImageUrlValidator._();

  /// Returns true if the URL is a valid image URL
  static bool isValid(String url) {
    if (url.isBlank) {
      return false;
    }

    final lowercaseUrl = url.toLowerCase();
    return (Uri.tryParse(url)?.hasAbsolutePath ?? false) &&
        (lowercaseUrl.endsWith('.jpg') ||
            lowercaseUrl.endsWith('.jpeg') ||
            lowercaseUrl.endsWith('.png') ||
            lowercaseUrl.endsWith('.gif') ||
            lowercaseUrl.endsWith('.webp') ||
            lowercaseUrl.endsWith('.bmp') ||
            lowercaseUrl.endsWith('.svg'));
  }
}
