import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_num_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class TokenField extends StatelessWidget {
  final VoicesIntFieldController? controller;
  final ValueChanged<int?>? onChanged;
  final ValueChanged<int?>? onFieldSubmitted;
  final VoicesNumFieldValidator<int>? validator;
  final String? labelText;
  final String? errorText;
  final String? placeholder;
  final FocusNode? focusNode;
  final NumRange<int>? range;
  final Currency currency;
  final bool showHelper;
  final bool enabled;
  final bool readOnly;
  final bool? ignorePointers;
  final Widget? helperWidget;

  const TokenField({
    super.key,
    this.controller,
    this.onChanged,
    required this.onFieldSubmitted,
    this.validator,
    this.labelText,
    this.errorText,
    this.placeholder,
    this.focusNode,
    this.range,
    this.currency = const Currency.ada(),
    this.showHelper = true,
    this.enabled = true,
    this.readOnly = false,
    this.ignorePointers,
    this.helperWidget,
  }) : assert(
          currency == const Currency.ada(),
          'Only supports ADA at the moment',
        );

  @override
  Widget build(BuildContext context) {
    final range = this.range;

    return VoicesIntField(
      controller: controller,
      focusNode: focusNode,
      decoration: VoicesTextFieldDecoration(
        labelText: labelText,
        errorText: errorText,
        prefixText: currency.symbol,
        hintText: range != null && range.min != null ? '${range.min}' : null,
        helper: helperWidget ??
            (showHelper
                ? _Helper(
                    currency: currency,
                    range: range,
                    placeholder: placeholder,
                  )
                : null),
        labelStyle: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
      validator: (int? value, text) => _validate(context, value, text),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      ignorePointers: ignorePointers,
    );
  }

  VoicesTextFieldValidationResult _validate(
    BuildContext context,
    int? value,
    String text,
  ) {
    // Value could not be parsed into int.
    if (value == null && text.isNotEmpty) {
      final message = context.l10n.errorValidationTokenNotParsed;
      return VoicesTextFieldValidationResult.error(message);
    }

    final validator = this.validator;
    if (validator != null) {
      return validator(value, text);
    }

    return const VoicesTextFieldValidationResult.none();
  }
}

class _Helper extends StatelessWidget {
  final Currency currency;
  final NumRange<int>? range;
  final String? placeholder;

  const _Helper({
    required this.currency,
    required this.range,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final min = range?.min;
    final max = range?.max;

    const boldStyle = TextStyle(fontWeight: FontWeight.bold);

    if (min != null && max != null) {
      return PlaceholderRichText(
        context.l10n.requestedAmountShouldBeBetweenMinAndMax,
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'min' => TextSpan(text: currency.format(min), style: boldStyle),
            'max' => TextSpan(text: currency.format(max), style: boldStyle),
            _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
          };
        },
        style: context.textTheme.bodySmall,
      );
    }

    if (min != null) {
      return PlaceholderRichText(
        context.l10n.requestedAmountShouldBeMoreThan,
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'min' => TextSpan(text: currency.format(min), style: boldStyle),
            _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
          };
        },
      );
    }

    if (max != null) {
      return PlaceholderRichText(
        context.l10n.requestedAmountShouldBeLessThan,
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'max' => TextSpan(text: currency.format(max), style: boldStyle),
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
