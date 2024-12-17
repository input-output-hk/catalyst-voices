import 'package:catalyst_voices_models/src/proposal_schema/proposal_definitions.dart';

class ProposalSchema {
  final String schema;
  final String title;
  final String description;
  final ProposalDefinitions definitions;
  final DefinitionsObjectTypes type;
  final bool additionalProperties;
  final List<ProposalSchemaSegment> properties;
  final List<String> order;

  const ProposalSchema({
    required this.schema,
    required this.title,
    required this.description,
    required this.definitions,
    required this.type,
    required this.additionalProperties,
    required this.properties,
    required this.order,
  });
}

class ProposalSchemaSegment {
  final BaseProposalDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<ProposalSchemaSection> properties;
  final List<String> required;
  final List<String> order;

  const ProposalSchemaSegment({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.properties,
    required this.required,
    required this.order,
  });
}

class ProposalSchemaSection {
  final BaseProposalDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<ProposalSchemaElement> properties;
  final List<String> required;
  final List<String> order;

  const ProposalSchemaSection({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.properties,
    required this.required,
    required this.order,
  });
}

class ProposalSchemaElement {
  final BaseProposalDefinition ref;
  final String id;
  final String title;
  final String description;
  final int? minLength;
  final int? maxLength;
  final String? defaultValue;
  final String guidance;
  final List<String>? enumValues;
  final int? maxItems;
  final int? minItems;
  final int? minimum;
  final int? maximum;
  final List<String> examples;

  const ProposalSchemaElement({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.minLength,
    required this.maxLength,
    required this.defaultValue,
    required this.guidance,
    required this.enumValues,
    required this.maxItems,
    required this.minItems,
    required this.minimum,
    required this.maximum,
    required this.examples,
  });
}
