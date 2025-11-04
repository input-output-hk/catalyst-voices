import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

sealed class ProposalOrDocument extends Equatable {
  const ProposalOrDocument();

  const factory ProposalOrDocument.data(DocumentData data) = _Document;

  const factory ProposalOrDocument.proposal(ProposalDocument data) = _Proposal;

  String? get authorName;

  // TODO(damian-molinski): Category name should come from query but atm those are not documents.
  String? get categoryName {
    return Campaign.all
        .map((e) => e.categories)
        .flattened
        .firstWhereOrNull((category) => category.selfRef == _category)
        ?.formattedCategoryName;
  }

  String? get description;

  int? get durationInMonths;

  Money? get fundsRequested;

  DocumentRef get selfRef;

  String? get title;

  String get version;

  SignedDocumentRef? get _category;
}

final class _Document extends ProposalOrDocument {
  final DocumentData data;

  const _Document(this.data);

  @override
  String? get authorName => data.metadata.authors?.firstOrNull?.username;

  @override
  String? get description => ProposalDocument.titleNodeId.from(data.content.data);

  @override
  int? get durationInMonths => ProposalDocument.descriptionNodeId.from(data.content.data);

  @override
  // without template we don't know currency so we can't Currencies.fallback or
  // assume major unit status
  Money? get fundsRequested => null;

  @override
  List<Object?> get props => [data];

  @override
  DocumentRef get selfRef => data.metadata.selfRef;

  @override
  String? get title => ProposalDocument.titleNodeId.from(data.content.data);

  @override
  String get version => data.metadata.selfRef.version!;

  @override
  SignedDocumentRef? get _category => data.metadata.categoryId;
}

final class _Proposal extends ProposalOrDocument {
  final ProposalDocument data;

  const _Proposal(this.data);

  @override
  String? get authorName => data.authorName;

  @override
  String? get description => data.description;

  @override
  int? get durationInMonths => data.duration;

  @override
  Money? get fundsRequested => data.fundsRequested;

  @override
  List<Object?> get props => [data];

  @override
  DocumentRef get selfRef => data.metadata.selfRef;

  @override
  String? get title => data.title;

  @override
  String get version => data.metadata.selfRef.version!;

  @override
  SignedDocumentRef? get _category => data.metadata.categoryId;
}

extension on DocumentNodeId {
  T? from<T extends Object>(Map<String, dynamic> data) {
    return DocumentNodeTraverser.getValue<T>(this, data);
  }
}
