import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class ProposalData extends Equatable {
  final ProposalDocument document;
  final String categoryId;
  final int commentsCount;
  final List<String> versions;

  const ProposalData({
    required this.document,
    required this.categoryId,
    this.commentsCount = 0,
    this.versions = const [],
  });

  String get proposalAuthor {
    final property =
        document.document.getProperty(ProposalDocument.authorNodeId)
            as DocumentValueProperty<String>?;

    return property?.value ?? '';
  }

  String get proposalDescription {
    final property =
        document.document.getProperty(ProposalDocument.descriptionNodeId)
            as DocumentValueProperty<String>?;

    return property?.value ?? '';
  }

  int get proposalDuration {
    final property =
        document.document.getProperty(ProposalDocument.durationNodeId)
            as DocumentValueProperty<int>?;

    return property?.value ?? 0;
  }

  Coin get proposalFundsRequested {
    final property =
        document.document.getProperty(ProposalDocument.requestedFundsNodeId)
            as DocumentValueProperty<int>?;

    return Coin(property?.value ?? 0);
  }

  String get proposalTitle {
    final property = document.document.getProperty(ProposalDocument.titleNodeId)
        as DocumentValueProperty<String>?;

    return property?.value ?? '';
  }

  @override
  List<Object?> get props => [
        document,
        categoryId,
        commentsCount,
        versions,
      ];
}
