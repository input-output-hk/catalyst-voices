import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/document/document_metadata.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class ProposalDocument extends Equatable {
  /// The maximum amount of proposal submitted for review per user.
  ///
  /// The limit does not have any effect on drafts or published proposals.
  static const int maxSubmittedProposalsPerUser = 6;

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
  static final categoryNodeId = DocumentNodeId.fromString('campaign_category');
  static final categoryDetailsNodeId =
      DocumentNodeId.fromString('campaign_category.category_details');
  static final milestonesNodeId = DocumentNodeId.fromString('milestones.milestones');
  static final milestoneListNodeId =
      DocumentNodeId.fromString('milestones.milestones.milestone_list');
  // This dot at the end is intentional.
  // More info: https://github.com/input-output-hk/catalyst-voices/pull/2640#discussion_r2115627064
  // It is used to indicate that the node id is a child of the milestone_list.
  // TODO(LynxLynxx): Add some sort of implementation of wildcards to the DocumentNodeId.
  // https://github.com/input-output-hk/catalyst-voices/issues/2661
  static final milestoneListChildNodeId =
      DocumentNodeId.fromString('milestones.milestones.milestone_list.');
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
    categoryNodeId,
    categoryDetailsNodeId,
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

  Coin? get fundsRequested {
    final property = document.getProperty(requestedFundsNodeId);

    if (property is! DocumentValueProperty<int>) {
      return null;
    }

    final value = property.value;
    if (value == null) return null;
    return Coin.fromWholeAda(value);
  }

  int? get milestoneCount {
    final property = document.getProperty(milestonesNodeId);

    if (property is! DocumentObjectProperty) {
      return null;
    }

    return DocumentNodeTraverser.findSectionsAndSubsections(property)
        .where((element) => element.nodeId.isChildOf(milestoneListNodeId))
        .length;
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
  static const categoryIdNode = NodeId('categoryId.id');
  static const authorsNode = NodeId('authors');

  final SignedDocumentRef templateRef;
  final SignedDocumentRef categoryId;
  final List<CatalystId> authors;

  ProposalMetadata({
    required super.selfRef,
    required this.templateRef,
    required this.categoryId,
    required this.authors,
  });

  @override
  List<Object?> get props => super.props + [templateRef, categoryId, authors];
}
