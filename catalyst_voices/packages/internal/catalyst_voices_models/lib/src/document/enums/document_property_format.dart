import 'package:catalyst_voices_models/src/money/currency.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// The format expected by the property value.
enum DocumentPropertyFormat {
  path('path'),
  uri('uri'),
  dropDownSingleSelect('dropDownSingleSelect'),
  multiSelect('multiSelect'),
  singleLineTextEntryList('singleLineTextEntryList'),
  singleLineTextEntryListMarkdown('singleLineTextEntryListMarkdown'),
  singleLineHttpsUrlEntryList('singleLineHttpsURLEntryList'),
  nestedQuestionsList('nestedQuestionsList'),
  nestedQuestions('nestedQuestions'),
  singleGroupedTagSelector('singleGroupedTagSelector'),
  tagGroup('tagGroup'),
  tagSelection('tagSelection'),
  tokenCardanoAda('token:cardano:ada', Currency.ada()),
  usd('usd', Currency.usd()),
  durationInMonths('datetime:duration:months'),
  yesNoChoice('yesNoChoice'),
  agreementConfirmation('agreementConfirmation'),
  spdxLicenseOrUrl('spdxLicenseOrURL'),
  unknown('unknown');

  /// The name of the format.
  final String value;

  /// The currency associated with the format or null if none associated.
  final Currency? currency;

  const DocumentPropertyFormat(this.value, [this.currency]);

  factory DocumentPropertyFormat.fromString(String string) {
    for (final format in values) {
      if (format.value.equalsIgnoreCase(string)) {
        return format;
      }
    }
    return DocumentPropertyFormat.unknown;
  }
}
