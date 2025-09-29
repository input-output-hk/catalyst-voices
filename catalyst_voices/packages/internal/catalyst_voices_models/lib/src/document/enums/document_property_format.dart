import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentAgreementConfirmationFormat extends DocumentPropertyFormat {
  const DocumentAgreementConfirmationFormat() : super('agreementConfirmation');
}

base class DocumentCurrencyFormat extends DocumentPropertyFormat {
  /// The currency the property value is denominated in.
  final Currency currency;

  /// The money units the property value is denominated in.
  ///
  /// Historically, for F14 the value was in major units (whole ADA)
  /// without lovelace (minor units).
  /// Starting from F15 the value will be denominated in minor units.
  ///
  /// To maintain backward compatibility the application
  /// needs to keep track what was denominated in which units.
  final MoneyUnits moneyUnits;

  const DocumentCurrencyFormat(
    super.value, {
    required this.currency,
    required this.moneyUnits,
  });

  @override
  List<Object?> get props => super.props + [currency, moneyUnits];

  /// Parses the [DocumentCurrencyFormat] from a [format].
  /// Returns `null` if format is unrecognized.
  ///
  /// Format:
  /// - token|fiat[:$brand]:$code[:$cent]
  ///
  /// Examples:
  /// - token:cardano:ada
  /// - token:cardano:ada:lovelace
  /// - token:usdm
  /// - token:usdm:cent
  /// - fiat:usd
  /// - fiat:usd:cent
  /// - fiat:eur
  /// - fiat:eur:cent
  static DocumentCurrencyFormat? parse(String format) {
    final parts = format.split(':');
    if (parts.length < 2) {
      return null;
    } else if (parts.first == 'token') {
      return _parseCryptocurrencyFormat(parts, format);
    } else if (parts.first == 'fiat') {
      return _parseFiatFormat(parts, format);
    } else {
      return null;
    }
  }

  static bool _isCentsFormat(String? string) {
    return switch (string) {
      'cent' || 'penny' || 'lovelace' || 'sat' || 'wei' => true,
      _ => false,
    };
  }

  /// token[:brand]:code[:cent]
  static DocumentCurrencyFormat? _parseCryptocurrencyFormat(List<String> parts, String format) {
    assert(parts.length >= 2, 'parts cannot be shorter than 2');
    assert(parts.first == 'token', 'first part must be "token"');

    if (parts.first == 'token') {
      String currencyCode;
      bool isMinorUnits;

      if (parts.length == 4) {
        currencyCode = parts[2];
        isMinorUnits = _isCentsFormat(parts[3]);
      } else if (parts.length == 3) {
        final brandOrCurrencyCode = parts[1];
        if (Currency.fromCode(brandOrCurrencyCode) != null) {
          // token:code:cent
          currencyCode = brandOrCurrencyCode;
          isMinorUnits = _isCentsFormat(parts[2]);
        } else {
          // token:brand:code
          currencyCode = parts[2];
          isMinorUnits = false;
        }
      } else {
        currencyCode = parts[1];
        isMinorUnits = false;
      }

      final currency = Currency.fromCode(currencyCode);
      if (currency != null) {
        return DocumentCurrencyFormat(
          format,
          currency: currency,
          moneyUnits: isMinorUnits ? MoneyUnits.minorUnits : MoneyUnits.majorUnits,
        );
      }
    }

    return null;
  }

  static DocumentCurrencyFormat? _parseFiatFormat(List<String> parts, String format) {
    assert(parts.length >= 2, 'parts cannot be shorter than 2');
    assert(parts.first == 'fiat', 'first part must be "fiat"');

    // fiat:code[:cent]
    final currencyCode = parts[1];
    final isMinorUnits = parts.length == 3 && _isCentsFormat(parts[2]);
    final currency = Currency.fromCode(currencyCode);
    if (currency != null) {
      return DocumentCurrencyFormat(
        format,
        currency: currency,
        moneyUnits: isMinorUnits ? MoneyUnits.minorUnits : MoneyUnits.majorUnits,
      );
    }
    return null;
  }
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
      // cspell: words dropdownsingleselect
      'dropdownsingleselect' => const DocumentDropdownSingleSelectFormat(),
      'multiselect' => const DocumentMultiSelectFormat(),
      // cspell: words singlelinetextentrylist
      'singlelinetextentrylist' => const DocumentSingleLineTextEntryListFormat(),
      // cspell: words singlelinetextentrylistmarkdown
      'singlelinetextentrylistmarkdown' => const DocumentSingleLineTextEntryListMarkdownFormat(),
      // cspell: words singlelinehttpsurlentrylist
      'singlelinehttpsurlentrylist' => const DocumentSingleLineHttpsUrlEntryListFormat(),
      // cspell: words nestedquestionslist
      'nestedquestionslist' => const DocumentNestedQuestionsListFormat(),
      // cspell: words nestedquestions
      'nestedquestions' => const DocumentNestedQuestionsFormat(),
      // cspell: words singlegroupedtagselector
      'singlegroupedtagselector' => const DocumentSingleGroupedTagSelectorFormat(),
      // cspell: words taggroup
      'taggroup' => const DocumentTagGroupFormat(),
      // cspell: words tagselection
      'tagselection' => const DocumentTagSelectionFormat(),
      'token:cardano:ada' => const DocumentTokenCardanoAdaFormat(),
      'datetime:duration:months' => const DocumentDurationMonthsFormat(),
      // cspell: words yesnochoice
      'yesnochoice' => const DocumentYesNoChoiceFormat(),
      // cspell: words agreementconfirmation
      'agreementconfirmation' => const DocumentAgreementConfirmationFormat(),
      // cspell: words spdxlicenseorurl
      'spdxlicenseorurl' => const DocumentSpdxLicenseOrUrlFormat(),
      _ => DocumentCurrencyFormat.parse(value) ?? const DocumentUnknownFormat(),
    };
  }

  @override
  List<Object?> get props => [value];
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
