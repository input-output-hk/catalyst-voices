extension UriExt on Uri {
  /// Formats the [Uri] skipping the scheme and scheme separator `://`.
  String toStringWithoutScheme() {
    final string = replace(scheme: '').toString();
    return string.replaceFirst('//', '');
  }
}
