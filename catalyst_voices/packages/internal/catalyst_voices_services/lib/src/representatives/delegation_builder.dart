import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// A builder for managing and submitting a delegation.
abstract interface class DelegationBuilder {
  /// The current number of representatives in the delegation.
  int get count;

  /// The maximum number of representatives allowed in the delegation.
  int get maxCount;

  /// The list of representatives currently in the delegation.
  List<Representative> get representatives;

  /// A stream that emits the list of representatives whenever it changes.
  Stream<List<Representative>> get watch;

  /// Adds a representative to the delegation.
  void add(Representative rep);

  /// Builds and submits the delegation.
  Future<Delegation> build();

  /// Disposes of the builder and releases any resources.
  void dispose();

  /// Removes a representative from the delegation.
  void remove(Representative rep);
}
