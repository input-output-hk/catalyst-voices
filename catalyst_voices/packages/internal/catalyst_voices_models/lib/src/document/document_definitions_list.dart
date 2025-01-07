part of 'document_definitions.dart';

final class SegmentDefinition extends BaseDocumentDefinition {
  final bool additionalProperties;

  const SegmentDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });

  @override
  Object? castValue(Object? value) {
    throw UnsupportedError('Segment cannot have a value');
  }

  @override
  DocumentProperty<Object> castProperty(DocumentProperty<Object> property) {
    throw UnsupportedError('Segment cannot have a property');
  }

  @override
  DocumentValidationResult validateProperty(DocumentProperty<Object> property) {
    return DocumentValidator.validateBasic(property);
  }

  @override
  List<Object?> get props => [
        type,
        note,
        additionalProperties,
      ];
}

final class SectionDefinition extends BaseDocumentDefinition {
  final bool additionalProperties;

  const SectionDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });

  @override
  Object? castValue(Object? value) {
    throw UnsupportedError('Section cannot have a value');
  }

  @override
  DocumentProperty<Object> castProperty(DocumentProperty<Object> property) {
    throw UnsupportedError('Section cannot have a property');
  }

  @override
  DocumentValidationResult validateProperty(DocumentProperty<Object> property) {
    return DocumentValidator.validateBasic(property);
  }

  @override
  List<Object?> get props => [
        additionalProperties,
        type,
        note,
      ];
}

final class SingleLineTextEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const SingleLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        contentMediaType,
        pattern,
        type,
        note,
      ];
}

final class SingleLineHttpsURLEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const SingleLineHttpsURLEntryDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}

final class MultiLineTextEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        contentMediaType,
        pattern,
        type,
        note,
      ];
}

final class MultiLineTextEntryMarkdownDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryMarkdownDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        contentMediaType,
        pattern,
        type,
        note,
      ];
}

final class DropDownSingleSelectDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const DropDownSingleSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        format,
        contentMediaType,
        pattern,
        type,
        note,
      ];
}

final class MultiSelectDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;

  const MultiSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<dynamic>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
      ];
}

final class SingleLineTextEntryListDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValues;
  final Map<String, dynamic> items;

  const SingleLineTextEntryListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValues,
    required this.items,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<String>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValues,
        items,
      ];
}

final class MultiLineTextEntryListMarkdownDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValue;
  final Map<String, dynamic> items;

  const MultiLineTextEntryListMarkdownDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<String>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
        items,
      ];
}

final class SingleLineHttpsURLEntryListDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValue;
  final Map<String, dynamic> items;

  const SingleLineHttpsURLEntryListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<String>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
        items,
      ];
}

final class NestedQuestionsListDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValue;

  const NestedQuestionsListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<String>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
      ];
}

// TODO(ryszard-schossler): Verify BaseDocumentDefinition type
final class NestedQuestionsDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool additionalProperties;

  const NestedQuestionsDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<String>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        additionalProperties,
        type,
        note,
      ];
}

// TODO(ryszard-schossler): Verify BaseDocumentDefinition type
final class SingleGroupedTagSelectorDefinition
    extends BaseDocumentDefinition<Map<String, dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool additionalProperties;

  const SingleGroupedTagSelectorDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<Map<String, dynamic>> property,
  ) {
    return DocumentValidator.validateBasic(property);
  }

  @override
  List<Object?> get props => [
        format,
        additionalProperties,
        type,
        note,
      ];
}

final class TagGroupDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const TagGroupDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}

final class TagSelectionDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const TagSelectionDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}

final class TokenValueCardanoADADefinition extends BaseDocumentDefinition<int> {
  final DocumentDefinitionsFormat format;

  const TokenValueCardanoADADefinition({
    required super.type,
    required super.note,
    required this.format,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<int> property) {
    return DocumentValidator.validateNum(property);
  }

  @override
  List<Object?> get props => [
        format,
        type,
        note,
      ];
}

final class DurationInMonthsDefinition extends BaseDocumentDefinition<int> {
  final DocumentDefinitionsFormat format;

  const DurationInMonthsDefinition({
    required super.type,
    required super.note,
    required this.format,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<int> property) {
    return DocumentValidator.validateNum(property);
  }

  @override
  List<Object?> get props => [
        type,
        note,
        format,
      ];
}

final class YesNoChoiceDefinition extends BaseDocumentDefinition<bool> {
  final DocumentDefinitionsFormat format;
  final bool defaultValue;

  const YesNoChoiceDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<bool> property) {
    return DocumentValidator.validateBool(property);
  }

  @override
  List<Object?> get props => [
        format,
        defaultValue,
        type,
        note,
      ];
}

final class AgreementConfirmationDefinition
    extends BaseDocumentDefinition<bool> {
  final DocumentDefinitionsFormat format;
  final bool defaultValue;
  final bool constValue;

  const AgreementConfirmationDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
    required this.constValue,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<bool> property) {
    return DocumentValidator.validateBool(property);
  }

  @override
  List<Object?> get props => [
        format,
        defaultValue,
        constValue,
        type,
        note,
      ];
}

final class SPDXLicenceOrUrlDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;
  final DocumentDefinitionsContentMediaType contentMediaType;

  const SPDXLicenceOrUrlDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
    required this.contentMediaType,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}

final class LanguageCodeDefinition extends BaseDocumentDefinition<String> {
  final String defaultValue;
  final List<String> enumValues;

  const LanguageCodeDefinition({
    required super.type,
    required super.note,
    required this.defaultValue,
    required this.enumValues,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        defaultValue,
        enumValues,
        note,
        type,
      ];
}
