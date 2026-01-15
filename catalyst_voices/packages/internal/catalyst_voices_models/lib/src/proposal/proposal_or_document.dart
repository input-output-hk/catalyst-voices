import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A sealed class that represents either a full proposal document with a
/// defined template (`ProposalDocument`) or a generic document without a
/// specific template (`DocumentData`).
///
/// This class provides a unified interface to access common properties
///
/// like [title], [description], etc., regardless of the
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

  /// Returns the underlying [ProposalDocument] if this is a proposal,
  /// or null if it's just a document without a template.
  ProposalDocument? get asProposalDocument => switch (this) {
    _Proposal(:final data) => data,
    _Document() => null,
  };

  Campaign? get campaign {
    return Campaign.all.firstWhereOrNull((campaign) => campaign.hasAnyParameterId(parameters));
  }

  CampaignCategory? get category {
    return Campaign.all
        .map((e) => e.categories)
        .flattened
        .firstWhereOrNull((category) => parameters.containsId(category.id.id));
  }

  /// The name of the proposal's category.
  String? get categoryName {
    return category?.formattedCategoryName;
  }

  /// A brief description of the proposal.
  String? get description;

  /// The duration of the proposal in months.
  int? get durationInMonths;

  /// The number of fund this proposal was submitted for.
  ///
  /// Fund number should come from query but atm those are not documents.
  int? get fundNumber {
    return Campaign.all
        .firstWhereOrNull((campaign) => campaign.hasAnyParameterId(parameters))
        ?.fundNumber;
  }

  /// The amount of funds requested by the proposal.
  Money? get fundsRequested;

  /// A reference to the document itself.
  DocumentRef get id;

  bool get isDocument => this is _Document;

  bool get isProposal => this is _Proposal;

  /// The title of the proposal.
  String? get title;

  /// A private getter for the category reference, used to find the
  /// [categoryName].
  DocumentParameters get parameters;
}

final class _Document extends ProposalOrDocument {
  final DocumentData data;

  const _Document(this.data);

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
  DocumentParameters get parameters => data.metadata.parameters;
}

final class _Proposal extends ProposalOrDocument {
  final ProposalDocument data;

  const _Proposal(this.data);

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
  DocumentParameters get parameters => data.metadata.parameters;
}

extension on DocumentNodeId {
  T? from<T extends Object>(Map<String, dynamic> data) {
    return DocumentNodeTraverser.getValue<T>(this, data);
  }
}
