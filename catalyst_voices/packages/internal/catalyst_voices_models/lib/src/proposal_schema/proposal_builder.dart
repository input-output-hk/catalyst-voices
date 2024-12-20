import 'package:catalyst_voices_models/src/proposal_schema/schema.dart';
import 'package:json_annotation/json_annotation.dart';

class ProposalBuilder {
  final String schema;
  final List<ProposalBuilderSegment> segments;

  const ProposalBuilder({
    required this.schema,
    required this.segments,
  });

  factory ProposalBuilder.build(Schema proposalSchema) {
    return ProposalBuilder(
      schema: proposalSchema.propertiesSchema,
      segments: proposalSchema.segments
          .map(
            (element) => ProposalBuilderSegment(
              id: element.id,
              sections: element.sections
                  .map(
                    (element) => ProposalBuilderSection(
                      id: element.id,
                      elements: element.elements
                          .map(
                            (e) => ProposalBuilderElement(
                              id: e.id,
                              value: e.ref.type.getDefaultValue,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}

class ProposalBuilderSegment {
  final String id;
  final List<ProposalBuilderSection> sections;

  const ProposalBuilderSegment({
    required this.id,
    required this.sections,
  });
}

@JsonSerializable()
class ProposalBuilderSection {
  final String id;
  final List<ProposalBuilderElement> elements;

  const ProposalBuilderSection({
    required this.id,
    required this.elements,
  });
}

class ProposalBuilderElement {
  final String id;
  final dynamic value;

  const ProposalBuilderElement({
    required this.id,
    required this.value,
  });
}
