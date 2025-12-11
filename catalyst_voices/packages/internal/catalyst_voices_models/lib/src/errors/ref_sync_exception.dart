import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RefSyncException extends Equatable implements Exception {
  final DocumentRef ref;
  final Object? source;

  const RefSyncException(this.ref, {this.source});

  @override
  List<Object?> get props => [ref, source];
}
