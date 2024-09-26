extension FutureExt<T> on Future<T> {
  /// The minimum loading delay after which the state changes from loading
  /// to success/failure will not be perceived too jumpy.
  ///
  /// Use it to avoid showing a loading state for split second.
  static const Duration minimumDelay = Duration(milliseconds: 300);

  /// Returns the result of awaiting the [Future]
  /// but applies a [minimumDelay] to it.
  Future<T> withMinimumDelay() async {
    final delay = Future<void>.delayed(minimumDelay);
    final result = await this;
    await delay;
    return result;
  }
}
