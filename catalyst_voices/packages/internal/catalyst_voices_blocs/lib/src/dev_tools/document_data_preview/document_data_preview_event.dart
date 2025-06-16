import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class DocumentDataPreviewEvent extends Equatable {
  const DocumentDataPreviewEvent();

  @override
  List<Object?> get props => [];
}

final class LookupRefDocumentsEvent extends DocumentDataPreviewEvent {
  final DocumentRef ref;

  const LookupRefDocumentsEvent({required this.ref});

  @override
  List<Object?> get props => [ref];
}
