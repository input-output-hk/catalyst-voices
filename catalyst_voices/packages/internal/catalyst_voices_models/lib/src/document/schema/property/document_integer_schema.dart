part of 'document_property_schema.dart';

final class DocumentCurrencySchema extends DocumentIntegerSchema {
  const DocumentCurrencySchema({
    required super.nodeId,
    required DocumentCurrencyFormat? super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
    required super.multipleOf,
  });

  /// Returns the currency associated with the [format]
  /// or [Currency.fallback] if there's no format defined.
  Currency get currency => format?.currency ?? const Currency.fallback();

  @override
  DocumentCurrencyFormat? get format => super.format as DocumentCurrencyFormat?;

  /// Returns the money units associated with the [format]
  /// or [MoneyUnits.fallback] if there's no format defined.
  MoneyUnits get moneyUnits => format?.moneyUnits ?? MoneyUnits.fallback;

  @override
  DocumentCurrencySchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentCurrencySchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      numRange: numRange,
      multipleOf: multipleOf,
    );
  }

  /// Converts the [money] instance to a raw value needed in the document data.
  ///
  /// The [money] instance is assumed to be created by [valueToMoney].
  int moneyToValue(Money money) {
    switch (moneyUnits) {
      case MoneyUnits.majorUnits:
        return money.majorUnits.toInt();
      case MoneyUnits.minorUnits:
        return money.minorUnits.toInt();
    }
  }

  /// Constructs an instance of [Money] according to the [format]
  /// from the [value] coming from the document data.
  ///
  /// If format not known then fallbacks to a historical representation used by the F14.
  Money valueToMoney(int value) {
    return Money.fromUnits(
      currency: currency,
      amount: BigInt.from(value),
      moneyUnits: moneyUnits,
    );
  }
}

final class DocumentDurationInMonthsSchema extends DocumentIntegerSchema {
  const DocumentDurationInMonthsSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
    required super.multipleOf,
  });

  @override
  DocumentDurationInMonthsSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentDurationInMonthsSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      numRange: numRange,
      multipleOf: multipleOf,
    );
  }
}

final class DocumentGenericIntegerSchema extends DocumentIntegerSchema {
  const DocumentGenericIntegerSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
    required super.multipleOf,
  });

  const DocumentGenericIntegerSchema.optional({
    required super.nodeId,
    super.format,
    super.title = '',
    super.description,
    super.placeholder,
    super.guidance,
    super.isSubsection = false,
    super.isRequired = false,
    super.defaultValue,
    super.constValue,
    super.enumValues,
    super.numRange,
    super.multipleOf,
  });

  @override
  DocumentGenericIntegerSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentGenericIntegerSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      numRange: numRange,
      multipleOf: multipleOf,
    );
  }
}

sealed class DocumentIntegerSchema extends DocumentValueSchema<int> {
  final NumRange<int>? numRange;
  final int? multipleOf;

  const DocumentIntegerSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required this.numRange,
    required this.multipleOf,
  }) : super(
         type: DocumentPropertyType.integer,
       );

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [numRange, multipleOf];

  @override
  DocumentIntegerSchema copyWith({DocumentNodeId? nodeId, String? title});

  @override
  DocumentValidationResult validate(int? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateIntegerRange(this, value),
      DocumentValidator.validateIntegerMultipleOf(this, value),
      DocumentValidator.validateConstValue(this, value),
      DocumentValidator.validateEnumValues(this, value),
    ]);
  }
}
