import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentAgreementConfirmationFormat extends DocumentPropertyFormat {
  const DocumentAgreementConfirmationFormat() : super('agreementConfirmation');
}

sealed class DocumentCurrencyFormat extends DocumentPropertyFormat {
  final Currency currency;
  final MoneyUnits moneyUnits;

  const DocumentCurrencyFormat(
    super.value, {
    required this.currency,
    required this.moneyUnits,
  });
}

final class DocumentDropdownSingleSelectFormat extends DocumentPropertyFormat {
  const DocumentDropdownSingleSelectFormat() : super('dropDownSingleSelect');
}

final class DocumentDurationMonthsFormat extends DocumentPropertyFormat {
  const DocumentDurationMonthsFormat() : super('datetime:duration:months');
}

final class DocumentMultiSelectFormat extends DocumentPropertyFormat {
  const DocumentMultiSelectFormat() : super('multiSelect');
}

final class DocumentNestedQuestionsFormat extends DocumentPropertyFormat {
  const DocumentNestedQuestionsFormat() : super('nestedQuestions');
}

final class DocumentNestedQuestionsListFormat extends DocumentPropertyFormat {
  const DocumentNestedQuestionsListFormat() : super('nestedQuestionsList');
}

final class DocumentPathFormat extends DocumentPropertyFormat {
  const DocumentPathFormat() : super('path');
}

/// The format expected by the property value.

sealed class DocumentPropertyFormat extends Equatable {
  final String value;

  const DocumentPropertyFormat(this.value);

  factory DocumentPropertyFormat.fromString(String string) {
    final value = string.toLowerCase();
    return switch (value) {
      'path' => const DocumentPathFormat(),
      'uri' => const DocumentUriFormat(),
      'dropdownsingleselect' => const DocumentDropdownSingleSelectFormat(),
      'multiselect' => const DocumentMultiSelectFormat(),
      'singlelinetextentrylist' => const DocumentSingleLineTextEntryListFormat(),
      'singlelinetextentrylistmarkdown' => const DocumentSingleLineTextEntryListMarkdownFormat(),
      // cspell: words singlelinehttpsurlentrylist
      'singlelinehttpsurlentrylist' => const DocumentSingleLineHttpsUrlEntryListFormat(),
      // cspell: words nestedquestionslist
      'nestedquestionslist' => const DocumentNestedQuestionsListFormat(),
      // cspell: words nestedquestions
      'nestedquestions' => const DocumentNestedQuestionsFormat(),
      // cspell: words singlegroupedtagselector
      'singlegroupedtagselector' => const DocumentSingleGroupedTagSelectorFormat(),
      'taggroup' => const DocumentTagGroupFormat(),
      'tagselection' => const DocumentTagSelectionFormat(),
      'token:cardano:ada' => const DocumentTokenCardanoAdaFormat(),
      'datetime:duration:months' => const DocumentDurationMonthsFormat(),
      // cspell: words yesnochoice
      'yesnochoice' => const DocumentYesNoChoiceFormat(),
      // cspell: words agreementconfirmation
      'agreementconfirmation' => const DocumentAgreementConfirmationFormat(),
      // cspell: words spdxlicenseorurl
      'spdxlicenseorurl' => const DocumentSpdxLicenseOrUrlFormat(),
      _ => _parseDynamicFormats(value),
    };
  }

  @override
  List<Object?> get props => [value];

  static DocumentPropertyFormat _parseDynamicFormats(String string) {
    final tokenRegex = RegExp(r'^token:([^:]+):([^:]+)$');
    final tokenMatch = tokenRegex.firstMatch(string);
    if (tokenMatch != null) {
      final x = tokenMatch.group(1);
    }

    return const DocumentUnknownFormat();
  }
}

final class DocumentSingleGroupedTagSelectorFormat extends DocumentPropertyFormat {
  const DocumentSingleGroupedTagSelectorFormat() : super('singleGroupedTagSelector');
}

final class DocumentSingleLineHttpsUrlEntryListFormat extends DocumentPropertyFormat {
  const DocumentSingleLineHttpsUrlEntryListFormat() : super('singleLineHttpsURLEntryList');
}

final class DocumentSingleLineTextEntryListFormat extends DocumentPropertyFormat {
  const DocumentSingleLineTextEntryListFormat() : super('singleLineTextEntryList');
}

final class DocumentSingleLineTextEntryListMarkdownFormat extends DocumentPropertyFormat {
  const DocumentSingleLineTextEntryListMarkdownFormat() : super('singleLineTextEntryListMarkdown');
}

final class DocumentSpdxLicenseOrUrlFormat extends DocumentPropertyFormat {
  const DocumentSpdxLicenseOrUrlFormat() : super('spdxLicenseOrURL');
}

final class DocumentTagGroupFormat extends DocumentPropertyFormat {
  const DocumentTagGroupFormat() : super('tagGroup');
}

final class DocumentTagSelectionFormat extends DocumentPropertyFormat {
  const DocumentTagSelectionFormat() : super('tagSelection');
}

final class DocumentTokenCardanoAdaFormat extends DocumentCurrencyFormat {
  const DocumentTokenCardanoAdaFormat()
    : super(
        'token:cardano:ada',
        currency: Currencies.ada,
        moneyUnits: MoneyUnits.majorUnits,
      );
}

final class DocumentUnknownFormat extends DocumentPropertyFormat {
  const DocumentUnknownFormat() : super('unknown');
}

final class DocumentUriFormat extends DocumentPropertyFormat {
  const DocumentUriFormat() : super('uri');
}

final class DocumentYesNoChoiceFormat extends DocumentPropertyFormat {
  const DocumentYesNoChoiceFormat() : super('yesNoChoice');
}
