import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/document/document_metadata.dart';
import 'package:equatable/equatable.dart';

final class ProposalDocument extends Equatable {
  /// A hardcoded [NodeId] of the title property.
  ///
  /// Since properties are dynamic the application cannot determine
  /// which property is the title in any other way than
  /// by hardcoding it's node ID.
  static final titleNodeId = DocumentNodeId.fromString('setup.title.title');
  static final descriptionNodeId =
      DocumentNodeId.fromString('summary.solution.summary');
  static final requestedFundsNodeId =
      DocumentNodeId.fromString('summary.budget.requestedFunds');
  static final durationNodeId =
      DocumentNodeId.fromString('summary.time.duration');
  static final authorNameNodeId =
      DocumentNodeId.fromString('summary.proposer.applicant');
  static final categoryNodeId = DocumentNodeId.fromString('campaign_category');
  static final categoryDetailsNodeId =
      DocumentNodeId.fromString('campaign_category.category_details.details');

  static const String exportFileExt = 'json';

  final ProposalMetadata metadata;
  final Document document;

  const ProposalDocument({
    required this.metadata,
    required this.document,
  });

  String? get authorName {
    final property = document.getProperty(ProposalDocument.authorNameNodeId);

    if (property is! DocumentValueProperty<String>) {
      return null;
    }

    return property.value;
  }

  String? get description {
    final property = document.getProperty(ProposalDocument.descriptionNodeId);

    if (property is! DocumentValueProperty<String>) {
      return null;
    }

    return property.value;
  }

  int? get duration {
    final property = document.getProperty(ProposalDocument.durationNodeId);

    if (property is! DocumentValueProperty<int>) {
      return null;
    }

    return property.value;
  }

  Coin? get fundsRequested {
    final nodeId = ProposalDocument.requestedFundsNodeId;
    final property = document.getProperty(nodeId);

    if (property is! DocumentValueProperty<int>) {
      return null;
    }

    final value = property.value;
    if (value == null) return null;
    return Coin(value);
  }

  @override
  List<Object?> get props => [
        metadata,
        document,
      ];

  String? get title {
    final property = document.getProperty(ProposalDocument.titleNodeId);

    if (property is! DocumentValueProperty<String>) {
      return null;
    }

    return property.value;
  }
}

final class ProposalMetadata extends DocumentMetadata {
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
