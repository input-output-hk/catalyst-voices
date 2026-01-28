import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// A builder for managing and submitting a delegation.
abstract interface class DelegationBuilder {
  factory DelegationBuilder() = DelegationBuilderImpl;

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
  Future<Delegation> build({
    required CatalystId delegatorId,
  });

  /// Removes local data.
  void clear();

  /// Disposes of the builder and releases any resources.
  Future<void> dispose();

  /// Removes a representative from the delegation.
  void remove(Representative rep);
}

final class DelegationBuilderImpl implements DelegationBuilder {
  static const _maxReps = 4;

  final List<Representative> _reps = [];
  final _repsSC = StreamController<List<Representative>>.broadcast();

  DelegationBuilderImpl();

  @override
  int get count => _reps.length;

  @override
  int get maxCount => _maxReps;

  @override
  List<Representative> get representatives => List.unmodifiable(_reps);

  @override
  Stream<List<Representative>> get watch async* {
    yield representatives;
    yield* _repsSC.stream;
  }

  @override
  void add(Representative rep) {
    if (_reps.length >= _maxReps) {
      throw const MaxDelegationRepresentativesReachedException(max: _maxReps);
    }

    _reps.add(rep);
    _repsSC.add(representatives);
  }

  @override
  Future<Delegation> build({
    required CatalystId delegatorId,
  }) async {
    final choices = _reps
        .map((e) => DelegationChoice(representativeId: e.id, representativeProfileId: e.profileId))
        .toList();

    return Delegation(delegatorId: delegatorId, choices: choices);
  }

  @override
  void clear() {
    _reps.clear();
    _repsSC.add(representatives);
  }

  @override
  Future<void> dispose() async {
    await _repsSC.close();
    _reps.clear();
  }

  @override
  void remove(Representative rep) {
    _reps.remove(rep);
    _repsSC.add(representatives);
  }
}
