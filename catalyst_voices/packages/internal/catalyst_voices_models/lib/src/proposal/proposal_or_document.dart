import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A sealed class that represents either a full proposal document with a
/// defined template (`ProposalDocument`) or a generic document without a
/// specific template (`DocumentData`).
///
/// This class provides a unified interface to access common properties
/// like [title], [author], [description], etc., regardless of the
/// underlying data type.
///
/// It's useful when dealing with list of proposals and some of them may not have templates
/// loaded yet.
sealed class ProposalOrDocument extends Equatable {
  const ProposalOrDocument();

  /// Creates a [ProposalOrDocument] from a generic [DocumentData].
  const factory ProposalOrDocument.data(DocumentData data) = _Document;

  /// Creates a [ProposalOrDocument] from a structured [ProposalDocument].
  const factory ProposalOrDocument.proposal(ProposalDocument data) = _Proposal;

  /// The id of the proposal's author.
  CatalystId? get author;

  // TODO(damian-molinski): Category name should come from query but atm those are not documents.
  /// The name of the proposal's category.
  String? get categoryName {
    return Campaign.all
        .map((e) => e.categories)
        .flattened
        .firstWhereOrNull((category) => category.id == _category)
        ?.formattedCategoryName;
  }

  /// A brief description of the proposal.
  String? get description;

  /// The duration of the proposal in months.
  int? get durationInMonths;

  /// The amount of funds requested by the proposal.
  Money? get fundsRequested;

  /// A reference to the document itself.
  DocumentRef get id;

  /// The title of the proposal.
  String? get title;

  /// The version of the document.
  String get version;

  /// A private getter for the category reference, used to find the
  /// [categoryName].
  SignedDocumentRef? get _category;
}

final class _Document extends ProposalOrDocument {
  final DocumentData data;

  const _Document(this.data);

  @override
  CatalystId? get author => data.metadata.authors?.firstOrNull;

  @override
  String? get description => ProposalDocument.titleNodeId.from(data.content.data);

  @override
  int? get durationInMonths => ProposalDocument.descriptionNodeId.from(data.content.data);

  @override
  // without template we don't know currency so we can't Currencies.fallback or
  // assume major unit status
  Money? get fundsRequested => null;

  @override
  DocumentRef get id => data.metadata.id;

  @override
  List<Object?> get props => [data];

  @override
  String? get title => ProposalDocument.titleNodeId.from(data.content.data);

  @override
  String get version => data.metadata.id.ver!;

  @override
  SignedDocumentRef? get _category => data.metadata.categoryId;
}

final class _Proposal extends ProposalOrDocument {
  final ProposalDocument data;

  const _Proposal(this.data);

  @override
  CatalystId? get author => data.authorId;

  @override
  String? get description => data.description;

  @override
  int? get durationInMonths => data.duration;

  @override
  Money? get fundsRequested => data.fundsRequested;

  @override
  DocumentRef get id => data.metadata.id;

  @override
  List<Object?> get props => [data];

  @override
  String? get title => data.title;

  @override
  String get version => data.metadata.id.ver!;

  @override
  SignedDocumentRef? get _category => data.metadata.categoryId;
}

extension on DocumentNodeId {
  T? from<T extends Object>(Map<String, dynamic> data) {
    return DocumentNodeTraverser.getValue<T>(this, data);
  }
}
