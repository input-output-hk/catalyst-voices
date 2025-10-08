import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A validator for [VoicesMoneyField].
typedef VoicesMoneyFieldValidator =
    VoicesTextFieldValidationResult Function(
      Money? value,
      String text,
    );

/// A [TextFormField] which allows to enter [Money].
///
/// The values are represented as instances of [String] / [Money] therefore the widget
/// is safe to handle any amount of monetary amount and will not fail with rounding issues
/// like [double] do when dealing with money.
class VoicesMoneyField extends StatefulWidget {
  /// Controller for managing the monetary value.
  final VoicesMoneyFieldController controller;

  /// Optional controller for additional widget states.
  final WidgetStatesController? statesController;

  /// Focus node for keyboard focus handling.
  final FocusNode? focusNode;

  /// Custom input formatters for the text field.
  final List<TextInputFormatter>? inputFormatters;

  /// Callback when the value changes.
  final ValueChanged<Money?>? onChanged;

  /// Callback when the field is submitted.
  final ValueChanged<Money?>? onFieldSubmitted;

  /// Validator for the field value.
  final VoicesMoneyFieldValidator? validator;

  /// Currency used for the field value.
  final Currency currency;

  /// Unit system used for money formatting.
  final MoneyUnits moneyUnits;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether to ignore pointer interactions.
  final bool? ignorePointers;

  /// Whether fractional amounts are allowed.
  final bool enableDecimals;

  /// Whether to display helper text.
  final bool showHelper;

  /// Optional minimum and maximum limits for the field.
  final OpenRange<Money>? range;

  /// Optional label text for the field.
  final String? labelText;

  /// Optional placeholder text for the field.
  final String? placeholder;

  /// Optional custom helper widget.
  final Widget? helperWidget;

  const VoicesMoneyField({
    super.key,
    required this.controller,
    this.statesController,
    this.focusNode,
    this.inputFormatters,
    this.onChanged,
    required this.onFieldSubmitted,
    this.validator,
    required this.currency,
    required this.moneyUnits,
    this.enabled = true,
    this.readOnly = false,
    this.ignorePointers,
    this.enableDecimals = true,
    this.showHelper = true,
    this.range,
    this.labelText,
    this.placeholder,
    this.helperWidget,
  });

  @override
  State<VoicesMoneyField> createState() => _VoicesMoneyFieldState();
}

/// A controller for [VoicesMoneyField].
class VoicesMoneyFieldController extends ValueNotifier<Money?> {
  VoicesMoneyFieldController(super.value);
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
            'min' => TextSpan(text: MoneyFormatter.formatDecimal(minMoney), style: boldStyle),
            'max' => TextSpan(text: MoneyFormatter.formatDecimal(maxMoney), style: boldStyle),
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
            'min' => TextSpan(text: MoneyFormatter.formatDecimal(minMoney), style: boldStyle),
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
            'max' => TextSpan(text: MoneyFormatter.formatDecimal(maxMoney), style: boldStyle),
            _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
          };
        },
      );
    }

    return const Text('');
  }
}

class _VoicesMoneyFieldState extends State<VoicesMoneyField> {
  late final TextEditingController textEditingController;

  VoicesMoneyFieldController get _controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final range = widget.range;
    final rangeMin = range?.min;

    final onChanged = widget.onChanged;
    final onFieldSubmitted = widget.onFieldSubmitted;

    return VoicesTextField(
      controller: textEditingController,
      statesController: widget.statesController,
      focusNode: widget.focusNode,
      decoration: VoicesTextFieldDecoration(
        labelText: widget.labelText,
        prefixText: MoneyFormatter.decorate(
          amount: '',
          decoration: MoneyDecoration.code,
          currency: widget.currency,
        ),
        hintText: rangeMin != null
            ? MoneyFormatter.formatExactAmount(
                rangeMin,
                decoration: MoneyDecoration.none,
              )
            : null,
        helper:
            widget.helperWidget ??
            (widget.showHelper
                ? _Helper(
                    range: range,
                    placeholder: widget.placeholder,
                  )
                : null),
        labelStyle: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        // Big values cannot be represented in the proposals template as numbers, therefore for
        // now we globally limit the maximum length to fit within the supported limit of `int`.
        DecimalTextInputFormatter(
          maxIntegerDigits: NumberUtils.maxSafeIntDigits - widget.currency.decimalDigits,
          maxDecimalDigits: widget.enableDecimals ? widget.currency.decimalDigits : 0,
        ),
        ...?widget.inputFormatters,
      ],
      onChanged: onChanged != null ? (value) => onChanged(_toMoney(value ?? '')) : null,
      onFieldSubmitted: onFieldSubmitted != null
          ? (value) => onFieldSubmitted(_toMoney(value))
          : null,
      textValidator: (value) => _validate(context, value),
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      ignorePointers: widget.ignorePointers,
    );
  }

  @override
  void didUpdateWidget(VoicesMoneyField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleMoneyChange);
      widget.controller.addListener(_handleMoneyChange);

      _handleMoneyChange();
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final money = _controller.value;
    final text = _toText(money);

    final textValue = TextEditingValueExt.collapsedAtEndOf(text ?? '');

    textEditingController = TextEditingController.fromValue(textValue)
      ..addListener(_handleTextChange);

    _controller.addListener(_handleMoneyChange);
  }

  void _handleMoneyChange() {
    final money = _controller.value;
    final text = _toText(money) ?? textEditingController.text;

    // encode to money again to prevent reseting text when money values are identical but the texts different
    // i.e. we consider these two to be equal and they should not trigger an update: "1.0" == "1."
    if (_toMoney(textEditingController.text) != _toMoney(text)) {
      textEditingController.textWithSelection = text;
    }
  }

  void _handleTextChange() {
    final text = textEditingController.text;
    final money = _toMoney(text);

    if (_controller.value != money) {
      _controller.value = money;
    }
  }

  Money? _toMoney(String text) {
    try {
      return Money.parse(text, widget.currency);
    } on FormatException {
      return null;
    }
  }

  String? _toText(Money? money) {
    try {
      if (money == null) {
        return null;
      }

      return MoneyFormatter.formatExactAmount(money, decoration: MoneyDecoration.none);
    } on FormatException {
      return null;
    }
  }

  VoicesTextFieldValidationResult _validate(
    BuildContext context,
    String text,
  ) {
    final money = _toMoney(text);
    if (money == null && text.isNotEmpty) {
      final message = context.l10n.errorValidationTokenNotParsed;
      return VoicesTextFieldValidationResult.error(message);
    }

    final validator = widget.validator;
    if (validator != null) {
      return validator(money, text);
    }

    return const VoicesTextFieldValidationResult.none();
  }
}
