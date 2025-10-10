import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices/widgets/text_field/voices_money_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DocumentCurrencyWidget extends StatefulWidget {
  final DocumentValueProperty<int> property;
  final DocumentCurrencySchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const DocumentCurrencyWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<DocumentCurrencyWidget> createState() {
    return _DocumentCurrencyWidgetState();
  }
}

class _DocumentCurrencyWidgetState extends State<DocumentCurrencyWidget> {
  late VoicesMoneyFieldController _controller;
  late final FocusNode _focusNode;

  bool get _isMilestone {
    return widget.property.nodeId.matchesPattern(ProposalDocument.milestoneCostNodeId);
  }

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;

    return VoicesMoneyField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _onChanged,
      onFieldSubmitted: _onChanged,
      validator: _validator,
      currency: schema.currency,
      moneyUnits: schema.moneyUnits,
      enabled: widget.isEditMode,
      ignorePointers: !widget.isEditMode,
      enableDecimals: schema.supportsDecimals,
      showHelper: widget.isEditMode,
      range: _numRangeToMoneyRange(schema.numRange),
      labelText: schema.title.isEmpty ? null : schema.formattedTitle,
      placeholder: schema.placeholder,
      helperWidget: _isMilestone ? const _MilestoneCostHelpText() : null,
    );
  }

  @override
  void didUpdateWidget(DocumentCurrencyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newSchema = widget.schema;
    final oldSchema = oldWidget.schema;
    final oldValue = oldWidget.property.value ?? oldSchema.defaultValue;
    final newValue = widget.property.value ?? newSchema.defaultValue;

    if (newSchema.currency != oldSchema.currency || newSchema.moneyUnits != oldSchema.moneyUnits) {
      _controller.dispose();
      _controller = VoicesMoneyFieldController(_valueToMoney(newValue));
    } else if (oldValue != newValue) {
      _controller.value = _valueToMoney(newValue);
    }

    if (widget.isEditMode != oldWidget.isEditMode) {
      _onEditModeChanged();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final money = _valueToMoney(widget.property.value ?? widget.schema.defaultValue);
    _controller = VoicesMoneyFieldController(money);
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  int? _moneyToValue(Money? money) {
    if (money == null) {
      return null;
    }

    return widget.schema.moneyToValue(money);
  }

  Range<Money?>? _numRangeToMoneyRange(Range<int?>? range) {
    if (range == null) {
      return null;
    }

    return Range(
      min: _valueToMoney(range.min),
      max: _valueToMoney(range.max),
    );
  }

  void _onChanged(Money? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: _moneyToValue(value),
    );

    widget.onChanged([change]);
  }

  void _onEditModeChanged() {
    _focusNode.canRequestFocus = widget.isEditMode;

    if (widget.isEditMode) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  VoicesTextFieldValidationResult _validator(Money? value, String text) {
    final schema = widget.schema;
    final result = schema.validate(_moneyToValue(value));
    if (result.isValid) {
      return const VoicesTextFieldValidationResult.none();
    } else {
      final localized = LocalizedDocumentValidationResult.from(result);
      return VoicesTextFieldValidationResult.error(localized.message(context));
    }
  }

  Money? _valueToMoney(int? value) {
    if (value == null) {
      return null;
    }

    return widget.schema.valueToMoney(value);
  }
}

class _MilestoneCostHelpText extends StatelessWidget {
  const _MilestoneCostHelpText();

  @override
  Widget build(BuildContext context) {
    return MarkdownText(
      MarkdownData(context.l10n.milestoneGuidelinesLink(VoicesConstants.milestoneGuideline)),
    );
  }
}
