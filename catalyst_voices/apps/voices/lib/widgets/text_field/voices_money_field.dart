import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_double_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

typedef VoicesMoneyFieldValidator =
    VoicesTextFieldValidationResult Function(
      Money? value,
      String text,
    );

class VoicesMoneyField extends StatelessWidget {
  final VoicesMoneyFieldController controller;
  final ValueChanged<Money?>? onChanged;
  final ValueChanged<Money?>? onFieldSubmitted;
  final VoicesMoneyFieldValidator? validator;
  final String? labelText;
  final String? errorText;
  final String? placeholder;
  final FocusNode? focusNode;
  final OpenRange<Money>? range;
  final bool enableDecimals;
  final bool showHelper;
  final bool enabled;
  final bool readOnly;
  final bool? ignorePointers;
  final Widget? helperWidget;

  const VoicesMoneyField({
    super.key,
    required this.controller,
    this.onChanged,
    required this.onFieldSubmitted,
    this.validator,
    this.labelText,
    this.errorText,
    this.placeholder,
    this.focusNode,
    this.range,
    this.enableDecimals = true,
    this.showHelper = true,
    this.enabled = true,
    this.readOnly = false,
    this.ignorePointers,
    this.helperWidget,
  });

  @override
  Widget build(BuildContext context) {
    final range = this.range;
    final rangeMin = range?.min;

    return VoicesDoubleField(
      controller: controller,
      focusNode: focusNode,
      decoration: VoicesTextFieldDecoration(
        labelText: labelText,
        errorText: errorText,
        prefixText: controller.currency.symbol,
        hintText: rangeMin != null
            ? MoneyFormatter.formatExactAmount(rangeMin, decoration: MoneyDecoration.none)
            : null,
        helper:
            helperWidget ??
            (showHelper
                ? _Helper(
                    range: range,
                    placeholder: placeholder,
                  )
                : null),
        labelStyle: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
      validator: (double? value, text) => _validate(context, value, text),
      onChanged: onChanged != null ? _onChanged : null,
      onFieldSubmitted: onFieldSubmitted != null ? _onFieldSubmitted : null,
      decimalDigits: enableDecimals ? controller.currency.decimalDigits : 0,
      enabled: enabled,
      readOnly: readOnly,
      ignorePointers: ignorePointers,
    );
  }

  void _onChanged(double? value) {
    onChanged?.call(_MoneyMath.doubleToMoney(controller.currency, controller.moneyUnits, value));
  }

  void _onFieldSubmitted(double? value) {
    onFieldSubmitted?.call(
      _MoneyMath.doubleToMoney(controller.currency, controller.moneyUnits, value),
    );
  }

  VoicesTextFieldValidationResult _validate(
    BuildContext context,
    double? value,
    String text,
  ) {
    final money = _MoneyMath.doubleToMoney(controller.currency, controller.moneyUnits, value);
    if (money == null && text.isNotEmpty) {
      final message = context.l10n.errorValidationTokenNotParsed;
      return VoicesTextFieldValidationResult.error(message);
    }

    final validator = this.validator;
    if (validator != null) {
      return validator(money, text);
    }

    return const VoicesTextFieldValidationResult.none();
  }
}

class VoicesMoneyFieldController extends VoicesDoubleFieldController {
  final Currency currency;
  final MoneyUnits moneyUnits;

  VoicesMoneyFieldController({
    required this.currency,
    required this.moneyUnits,
    Money? value,
  }) : super(_MoneyMath.moneyToDouble(value));

  Money? get money {
    return _MoneyMath.doubleToMoney(currency, moneyUnits, value);
  }

  set money(Money? money) {
    value = _MoneyMath.moneyToDouble(money);
  }
}

class _Helper extends StatelessWidget {
  final OpenRange<Money>? range;
  final String? placeholder;

  const _Helper({
    required this.range,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final minMoney = range?.min;
    final maxMoney = range?.max;

    const boldStyle = TextStyle(fontWeight: FontWeight.bold);

    if (minMoney != null && maxMoney != null) {
      return PlaceholderRichText(
        context.l10n.requestedAmountShouldBeBetweenMinAndMax('{min}', '{max}'),
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'min' => TextSpan(text: MoneyFormatter.formatExactAmount(minMoney), style: boldStyle),
            'max' => TextSpan(text: MoneyFormatter.formatExactAmount(maxMoney), style: boldStyle),
            _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
          };
        },
        style: context.textTheme.bodySmall,
      );
    }

    if (minMoney != null) {
      return PlaceholderRichText(
        context.l10n.requestedAmountShouldBeMoreThan('{min}'),
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'min' => TextSpan(text: MoneyFormatter.formatExactAmount(minMoney), style: boldStyle),
            _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
          };
        },
      );
    }

    if (maxMoney != null) {
      return PlaceholderRichText(
        context.l10n.requestedAmountShouldBeLessThan('{max}'),
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'max' => TextSpan(text: MoneyFormatter.formatExactAmount(maxMoney), style: boldStyle),
            _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
          };
        },
      );
    }

    if (placeholder != null) {
      return Text(placeholder!);
    }

    return const Text('');
  }
}

class _MoneyMath {
  static Money? doubleToMoney(Currency currency, MoneyUnits moneyUnits, double? value) {
    if (value == null) {
      return null;
    }

    switch (moneyUnits) {
      case MoneyUnits.majorUnits:
        return Money.fromMajorUnits(
          currency: currency,
          majorUnits: BigInt.from(value),
        );
      case MoneyUnits.minorUnits:
        return Money(
          currency: currency,
          minorUnits: BigInt.from(value * currency.decimalDigitsFactor.toInt()),
        );
    }
  }

  static double? moneyToDouble(Money? money) {
    if (money == null) {
      return null;
    }

    final value = money.minorUnits / money.currency.decimalDigitsFactor;
    return value.truncateToDecimals(money.currency.decimalDigits);
  }
}
