import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentIndex extends Equatable {
  final List<SignedDocumentRef> refs;
  final DocumentIndexPage page;

  const DocumentIndex({
    required this.refs,
    required this.page,
  });

  @override
  List<Object?> get props => [refs, page];
}

final class DocumentIndexPage extends Equatable {
  final int page;
  final int limit;
  final int remaining;

  const DocumentIndexPage({
    required this.page,
    required this.limit,
    required this.remaining,
  });

  @override
  List<Object?> get props => [page, limit, remaining];
}
