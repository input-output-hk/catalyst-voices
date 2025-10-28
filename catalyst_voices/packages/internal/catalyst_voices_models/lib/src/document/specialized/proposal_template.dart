import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/document/document_metadata.dart';
import 'package:equatable/equatable.dart';

final class ProposalTemplate extends Equatable {
  final ProposalTemplateMetadata metadata;
  final DocumentSchema schema;

  const ProposalTemplate({
    required this.metadata,
    required this.schema,
  });

  @override
  List<Object?> get props => [
    metadata,
    schema,
  ];

  DocumentStringSchema? get title {
    final property = schema.getPropertySchema(ProposalDocument.titleNodeId);
    return property is DocumentStringSchema ? property : null;
  }
}

final class ProposalTemplateMetadata extends DocumentMetadata {
  ProposalTemplateMetadata({
    required super.selfRef,
    required super.parameters,
  });
}
