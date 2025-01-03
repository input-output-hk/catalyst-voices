import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class TokenField extends StatelessWidget {
  final VoicesIntFieldController? controller;
  final ValueChanged<int?>? onFieldSubmitted;
  final ValueChanged<VoicesTextFieldStatus>? onStatusChanged;
  final String? labelText;
  final String? errorText;
  final FocusNode? focusNode;
  final Range<int>? range;
  final Currency currency;
  final bool showHelper;
  final bool readOnly;
  final bool? ignorePointers;

  const TokenField({
    super.key,
    this.controller,
    required this.onFieldSubmitted,
    this.onStatusChanged,
    this.labelText,
    this.errorText,
    this.focusNode,
    this.range,
    this.currency = const Currency.ada(),
    this.showHelper = true,
    this.readOnly = false,
    this.ignorePointers,
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
        hintText: range != null ? '${range.min}' : null,
        filled: true,
        helper: range != null && showHelper
            ? _Helper(
                symbol: currency.symbol,
                range: range,
              )
            : null,
      ),
      validator: (int? value, text) => _validate(context, value, text),
      onStatusChanged: onStatusChanged,
      onFieldSubmitted: onFieldSubmitted,
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

    if (value != null && !(range?.contains(value) ?? true)) {
      // Do not append any text
      return const VoicesTextFieldValidationResult.error();
    }

    return const VoicesTextFieldValidationResult.none();
  }
}

class _Helper extends StatelessWidget {
  final String symbol;
  final Range<int> range;

  const _Helper({
    required this.symbol,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): Refactor text formatting with smarter syntax
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: context.l10n.requestedAmountShouldBeBetween),
          const TextSpan(text: ' '),
          TextSpan(
            text: '$symbol${range.min}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' '),
          TextSpan(text: context.l10n.and),
          const TextSpan(text: ' '),
          TextSpan(
            text: '$symbol${range.max}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
