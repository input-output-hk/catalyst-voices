import 'package:catalyst_voices_models/src/proposal_template/definitions/definition.dart';

final class SchemaReferenceDefinition extends Definition {
  final bool readOnly;

  const SchemaReferenceDefinition({
    required this.readOnly,
    required String format,
  }) : super(
          type: 'string',
          format: format,
        );
}

final class DropDownSingleSelectDefinition extends Definition {
  const DropDownSingleSelectDefinition()
      : super(
          type: 'string',
          contentMediaType: 'text/plain',
          pattern: r'^.*$',
          format: 'dropDownSingleSelect',
        );
}

final class MultiSelectDefinition extends Definition {
  final bool uniqueItems;

  const MultiSelectDefinition({
    this.uniqueItems = true,
  }) : super(
          type: 'array',
          format: 'multiSelect',
        );
}

final class TokenValueCardanoADADefinition extends Definition {
  const TokenValueCardanoADADefinition()
      : super(
          type: 'integer',
          format: 'token:cardano:ada',
        );
}

final class DurationInMonthsDefinition extends Definition {
  const DurationInMonthsDefinition()
      : super(
          type: 'integer',
          format: 'datetime:duration:months',
        );
}

final class YesNoChoiceDefinition extends Definition {
  final bool defaultValue;

  const YesNoChoiceDefinition({
    this.defaultValue = false,
  }) : super(
          type: 'boolean',
          format: 'yesNoChoice',
        );
}

final class AgreementConfirmationDefinition extends Definition {
  final bool defaultValue;
  final bool constValue;

  const AgreementConfirmationDefinition({
    this.defaultValue = false,
    this.constValue = true,
  }) : super(
          type: 'boolean',
          format: 'agreementConfirmation',
        );
}

final class SPDXLicenseOrURLDefinition extends Definition {
  const SPDXLicenseOrURLDefinition()
      : super(
          type: 'string',
          contentMediaType: 'text/plain',
          pattern: r'^.*$',
          format: 'spdxLicenseOrURL',
        );
}
