import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

// Note. Supports only ADA now but should be converted to money2 package
// for different currencies support.
class TokenField extends StatelessWidget {
  final VoicesIntFieldController? controller;
  final ValueChanged<int?>? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool isRequired;
  final int min;
  final int max;
  final Currency currency;

  const TokenField({
    super.key,
    this.controller,
    required this.onFieldSubmitted,
    this.focusNode,
    this.isRequired = true,
    required this.min,
    required this.max,
    this.currency = const Currency.ada(),
  }) : assert(
          currency == const Currency.ada(),
          'Only supports ADA at the moment',
        );

  @override
  Widget build(BuildContext context) {
    var label = context.l10n.requestedFundsInCurrency(currency.name);
    if (isRequired) {
      label = '*$label';
    }

    return VoicesIntField(
      controller: controller,
      focusNode: focusNode,
      decoration: VoicesTextFieldDecoration(
        labelText: label,
        prefixText: currency.symbol,
        hintText: '$min',
        filled: true,
        helper: _Helper(
          symbol: currency.symbol,
          min: min,
          max: max,
        ),
      ),
      validator: _validate,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  VoicesTextFieldValidationResult _validate(int? num, String text) {
    return const VoicesTextFieldValidationResult.none();
  }
}

class _Helper extends StatelessWidget {
  final String symbol;
  final int min;
  final int max;

  const _Helper({
    required this.symbol,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${context.l10n.requestedAmountShouldBeBetween} '),
          TextSpan(
            text: '$symbol$min',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' ${context.l10n.and} '),
          TextSpan(
            text: '$symbol$max',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
