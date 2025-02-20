import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class RefsSyncException extends SyncException {
  final List<Object> errors;

  RefsSyncException(this.errors);

  @override
  String toString() => 'RefsSyncException errors[${errors.length}]';
}

final class RefSyncException extends SyncException {
  final DocumentRef ref;
  final Object? error;
  final StackTrace? stack;

  const RefSyncException(this.ref, {this.error, this.stack});

  @override
  String toString() => 'RefSyncException($ref) failed with $error';
}

sealed class SyncException implements Exception {
  const SyncException();
}
