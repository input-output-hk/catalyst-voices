import 'package:catalyst_voices_models/src/proposal_schema/schema.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_builder.g.dart';

@JsonSerializable()
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

  factory ProposalBuilder.fromJson(Map<String, dynamic> json) =>
      _$ProposalBuilderFromJson(json);

  Map<String, dynamic> toJson() {
    final sections = <String, dynamic>{}..addAll({r'$schema': schema});
    for (final section in segments) {
      sections.addAll(section.toJson());
    }
    return sections;
  }
}

@JsonSerializable()
class ProposalBuilderSegment {
  final String id;
  final List<ProposalBuilderSection> sections;

  const ProposalBuilderSegment({
    required this.id,
    required this.sections,
  });

  factory ProposalBuilderSegment.fromJson(Map<String, dynamic> json) =>
      _$ProposalBuilderSegmentFromJson(json);

  Map<String, dynamic> toJson() {
    final sections = <String, dynamic>{};
    for (final section in this.sections) {
      sections.addAll(section.toJson());
    }
    return {
      id: sections,
    };
  }
}

@JsonSerializable()
class ProposalBuilderSection {
  final String id;
  final List<ProposalBuilderElement> elements;

  const ProposalBuilderSection({
    required this.id,
    required this.elements,
  });

  factory ProposalBuilderSection.fromJson(Map<String, dynamic> json) =>
      _$ProposalBuilderSectionFromJson(json);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    for (final element in elements) {
      map.addAll(element.toJson());
    }
    return {
      id: map,
    };
  }
}

@JsonSerializable()
class ProposalBuilderElement {
  final String id;
  final dynamic value;

  const ProposalBuilderElement({
    required this.id,
    required this.value,
  });

  factory ProposalBuilderElement.fromJson(Map<String, dynamic> json) =>
      _$ProposalBuilderElementFromJson(json);

  Map<String, dynamic> toJson() => {
        id: value,
      };
}
