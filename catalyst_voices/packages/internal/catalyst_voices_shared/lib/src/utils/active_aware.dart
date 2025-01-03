/// An interface for objects that can be active or inactive.
///
/// Active objects are typically performing some kind of work or are ready to
/// do so. Inactive objects are not currently performing any work.
abstract interface class ActiveAware {
  /// Whether this vault is currently being used.
  bool get isActive;

  /// Updates usage status.
  set isActive(bool value);
}
