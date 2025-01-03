import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'defined_property/single_grouped_tag_selector.dart';

final _logger = Logger('DocumentDefinedProperty');

sealed class DocumentDefinedProperty extends Equatable {
  final bool isRequired;

  const DocumentDefinedProperty({
    required this.isRequired,
  });

  factory DocumentDefinedProperty.from(DocumentSchemaProperty property) {
    switch (property.definition) {
      case SegmentDefinition():
      case SectionDefinition():
        throw ArgumentError(
          '${property.definition.runtimeType} is not valid property definition',
        );
      case SingleLineTextEntryDefinition():
      case SingleLineHttpsURLEntryDefinition():
      case MultiLineTextEntryDefinition():
      case MultiLineTextEntryMarkdownDefinition():
      case DropDownSingleSelectDefinition():
      case MultiSelectDefinition():
      case SingleLineTextEntryListDefinition():
      case MultiLineTextEntryListMarkdownDefinition():
      case SingleLineHttpsURLEntryListDefinition():
      case NestedQuestionsListDefinition():
      case NestedQuestionsDefinition():
        throw UnimplementedError(
          'Definition ${property.definition} defined property not implemented',
        );
      case SingleGroupedTagSelectorDefinition():
        return SingleGroupedTagSelector.from(
          oneOf: property.oneOf ?? const [],
          isRequired: property.isRequired,
        );
      case TagGroupDefinition():
      case TagSelectionDefinition():
        throw ArgumentError(
          '${property.definition.runtimeType} is not valid property definition',
        );
      case TokenValueCardanoADADefinition():
      case DurationInMonthsDefinition():
      case YesNoChoiceDefinition():
      case AgreementConfirmationDefinition():
      case SPDXLicenceOrUrlDefinition():
        throw UnimplementedError(
          'Definition ${property.definition} defined property not implemented',
        );
    }
  }

  @override
  @mustBeOverridden
  List<Object?> get props => [isRequired];
}
