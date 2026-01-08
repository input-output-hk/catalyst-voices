import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/document/document_metadata.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class ProposalDocument extends Equatable {
  /// The maximum amount of proposal submitted for review per user.
  ///
  /// The limit does not have any effect on drafts or published proposals.
  static const int maxSubmittedProposalsPerUser = 2;

  /// A hardcoded [NodeId] of the title property.
  ///
  /// Since properties are dynamic the application cannot determine
  /// which property is the title in any other way than
  /// by hardcoding it's node ID.
  ///
  /// Some of nodes are used as paths for db jsonb queries.
  static final titleNodeId = DocumentNodeId.fromString('setup.title.title');
  static final descriptionNodeId = DocumentNodeId.fromString('summary.solution.summary');
  static final requestedFundsNodeId = DocumentNodeId.fromString('summary.budget.requestedFunds');
  static final durationNodeId = DocumentNodeId.fromString('summary.time.duration');
  static final authorNameNodeId = DocumentNodeId.fromString('setup.proposer.applicant');
  static final categoryDetailsNodeId = DocumentNodeId.fromString(
    'campaign_category.category_details',
  );
  static final categoryDetailsNameNodeId = DocumentNodeId.fromString(
    'campaign_category.category_details.details',
  );
  static final milestonesNodeId = DocumentNodeId.fromString('milestones.milestones');
  static final milestoneListNodeId = DocumentNodeId.fromString(
    'milestones.milestones.milestone_list',
  );
  static final milestoneListChildNodeId = DocumentNodeId.fromString(
    'milestones.milestones.milestone_list.*',
  );
  static final milestoneCostNodeId = DocumentNodeId.fromString(
    'milestones.milestones.milestone_list.*.cost',
  );
  static final tagNodeId = DocumentNodeId.fromString('theme.theme.grouped_tag');

  /// A list of all [DocumentNodeId] that are expected to appear
  /// in the proposal template schema.
  ///
  /// The app builds custom logic on top of these node ids.
  static final allNodeIds = [
    titleNodeId,
    descriptionNodeId,
    requestedFundsNodeId,
    durationNodeId,
    authorNameNodeId,
    categoryDetailsNodeId,
    categoryDetailsNameNodeId,
    milestonesNodeId,
    milestoneListNodeId,
    tagNodeId,
  ];

  static const String exportFileExt = 'json';

  final ProposalMetadata metadata;
  final Document document;

  const ProposalDocument({
    required this.metadata,
    required this.document,
  });

  CatalystId? get authorId => metadata.authors.firstOrNull;

  String? get authorName => _metadataAuthorName ?? _contentAuthorName;

  String? get description {
    final property = document.getProperty(descriptionNodeId);

    if (property is! DocumentValueProperty<String>) {
      return null;
    }

    return property.value;
  }

  int? get duration {
    final property = document.getProperty(durationNodeId);

    if (property is! DocumentValueProperty<int>) {
      return null;
    }

    return property.value;
  }

  Money? get fundsRequested {
    final property = document.getProperty(requestedFundsNodeId);

    if (property is! DocumentValueProperty<int>) {
      return null;
    }

    final value = property.value;
    if (value == null) {
      return null;
    }

    final schema = property.schema;
    if (schema is! DocumentCurrencySchema) {
      return null;
    }

    return schema.valueToMoney(value);
  }

  int? get milestoneCount {
    final property = document.getProperty(milestonesNodeId);

    if (property is! DocumentObjectProperty) {
      return null;
    }

    return DocumentNodeTraverser.findSectionsAndSubsections(
      property,
    ).where((element) => element.nodeId.isSameOrChildOf(milestoneListNodeId)).length;
  }

  @override
  List<Object?> get props => [
    metadata,
    document,
  ];

  String? get tag {
    final property = document.getProperty(tagNodeId);
    final scheme = property?.schema;

    if (property is! DocumentObjectProperty || scheme is! DocumentSingleGroupedTagSelectorSchema) {
      return null;
    }

    return scheme.groupedTagsSelection(property)?.toString();
  }

  String? get title {
    final property = document.getProperty(titleNodeId);

    if (property is! DocumentValueProperty<String>) {
      return null;
    }

    return property.value;
  }

  String? get _contentAuthorName {
    final property = document.getProperty(authorNameNodeId);

    if (property is! DocumentValueProperty<String>) {
      return null;
    }

    return property.value;
  }

  String? get _metadataAuthorName => metadata.authors.firstOrNull?.username;
}

final class ProposalMetadata extends DocumentMetadata {
  /// Proposal parameters like brand, campaign or category.
  ///
  /// Legacy documents stored them in separate fields, see [categoryIdNode].
  static const parametersNode = NodeId('parameters');

  /// The id part of the [parametersNode].
  static const parametersIdNode = NodeId('parameters.*.id');

  /// Legacy parameter name for the category. New format of the metadata uses [parameters].
  static const categoryIdNode = NodeId('categoryId.id');
  static const authorsNode = NodeId('authors');

  final SignedDocumentRef templateRef;
  final List<CatalystId> authors;

  ProposalMetadata({
    required super.selfRef,
    required super.parameters,
    required this.templateRef,
    required this.authors,
  });

  @override
  List<Object?> get props => super.props + [templateRef, authors];
}
