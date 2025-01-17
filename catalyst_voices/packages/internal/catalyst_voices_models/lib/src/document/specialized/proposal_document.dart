import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/document/document_metadata.dart';
import 'package:equatable/equatable.dart';

final class ProposalDocument extends Equatable {
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
  const ProposalMetadata({
    required super.id,
    required super.version,
  });
}
