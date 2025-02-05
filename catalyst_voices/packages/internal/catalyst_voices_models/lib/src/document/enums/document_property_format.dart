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
  tokenCardanoAda('token:cardano:ada'),
  durationInMonths('datetime:duration:months'),
  yesNoChoice('yesNoChoice'),
  agreementConfirmation('agreementConfirmation'),
  spdxLicenseOrUrl('spdxLicenseOrURL'),
  unknown('unknown');

  final String value;

  const DocumentPropertyFormat(this.value);

  factory DocumentPropertyFormat.fromString(String string) {
    for (final format in values) {
      if (format.value.toLowerCase() == string.toLowerCase()) {
        return format;
      }
    }
    return DocumentPropertyFormat.unknown;
  }
}
