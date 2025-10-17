import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class RefsSyncException extends SyncException {
  final List<Object> errors;

  const RefsSyncException(this.errors);

  @override
  String toString() => 'RefsSyncException errors[${errors.length}]';
}

final class RefSyncException extends SyncException {
  final DocumentRef ref;
  final Object? error;

  const RefSyncException(this.ref, {this.error});

  @override
  String toString() => 'RefSyncException($ref) failed with $error';
}
