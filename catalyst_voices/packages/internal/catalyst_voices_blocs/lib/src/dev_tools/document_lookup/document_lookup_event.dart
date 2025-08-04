import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class DocumentLookupEvent extends Equatable {
  const DocumentLookupEvent();

  @override
  List<Object?> get props => [];
}

final class LookupRefDocumentsEvent extends DocumentLookupEvent {
  final DocumentRef ref;

  const LookupRefDocumentsEvent({required this.ref});

  @override
  List<Object?> get props => [ref];
}
