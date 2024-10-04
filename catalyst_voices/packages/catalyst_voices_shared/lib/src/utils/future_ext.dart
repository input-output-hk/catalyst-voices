extension FutureExt<T> on Future<T> {
  /// The minimum loading delay after which the state changes from loading
  /// to success/failure will not be perceived too jumpy.
  ///
  /// Use it to avoid showing a loading state for split second.
  static const Duration minimumDelay = Duration(milliseconds: 300);

  /// Returns the result of awaiting the [Future]
  /// but applies [delay] to it or [minimumDelay] if [delay] is null.
  Future<T> withMinimumDelay([Duration delay = minimumDelay]) async {
    final delayed = Future<void>.delayed(delay);
    final result = await this;
    await delayed;
    return result;
  }
}
