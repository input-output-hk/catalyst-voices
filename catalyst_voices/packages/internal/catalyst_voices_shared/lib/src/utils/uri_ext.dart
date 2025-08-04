extension UriExt on Uri {
  String decoded() => Uri.decodeFull(toString());

  /// Formats the [Uri] skipping the scheme and scheme separator `://`.
  String toStringWithoutScheme() {
    final string = replace(scheme: '').toString();
    return string.replaceFirst('//', '');
  }
}
