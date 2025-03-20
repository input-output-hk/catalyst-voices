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
  static const String exportFileExt = 'json';

  final ProposalMetadata metadata;
  final Document document;

  const ProposalDocument({
    required this.metadata,
    required this.document,
  });

  @override
  List<Object?> get props => [
        metadata,
        document,
      ];
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
