import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A wrapper class that holds data of type [T] and its current [state].
///
/// This is useful for representing the state of an asynchronous operation,
/// for example, synchronizing voting power.
final class Snapshot<T extends Object> extends Equatable {
  /// The data of the snapshot.
  /// It can be `null` if the operation is not yet complete or has failed.
  final T? data;

  /// The error of the snapshot.
  final Exception? error;

  /// The current state of the snapshot.
  final SnapshotState state;

  /// Creates a new [Snapshot] instance.
  ///
  /// By default, the state is [SnapshotState.idle].
  const Snapshot({
    this.data,
    this.error,
    this.state = SnapshotState.idle,
  });

  /// Creates a new [Snapshot] with an `active` state.
  ///
  /// The data can be present while the operation is still in progress.
  const Snapshot.active({this.data, this.error}) : state = SnapshotState.active;

  /// Creates a new [Snapshot] with an `data` state.
  ///
  /// The [data] should be present when the operation has succeeded.
  const Snapshot.data(
    this.data, {
    required this.state,
  }) : error = null;

  /// Creates a new [Snapshot] with a `done` state.
  ///
  /// The data should be present when the operation is complete.
  const Snapshot.done({this.data, this.error}) : state = SnapshotState.done;

  /// Creates a new [Snapshot] with an `error` state.
  ///
  /// The [error] should be present when the operation has failed.
  const Snapshot.error(
    this.error, {
    required this.state,
  }) : data = null;

  /// Creates a new [Snapshot] with an `idle` state.
  ///
  /// The data is typically `null` in this state.
  const Snapshot.idle({this.data, this.error}) : state = SnapshotState.idle;

  @override
  List<Object?> get props => [data, error, state];

  Snapshot<T> copyWith({
    Optional<T>? data,
    Optional<Exception>? error,
    SnapshotState? state,
  }) {
    return Snapshot(
      data: data.dataOr(this.data),
      error: error.dataOr(this.error),
      state: state ?? this.state,
    );
  }
}

/// Represents the state of a [Snapshot].
enum SnapshotState {
  /// The operation has not started.
  idle,

  /// The operation is in progress.
  active,

  /// The operation has completed.
  done,
}
