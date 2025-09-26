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

  // TODO(LynxxLynx): After https://github.com/input-output-hk/catalyst-voices/pull/2865
  // is merged use wildcard support for NodeId
  bool get _isMilestone {
    final milestoneWildcardNodeId = ProposalDocument.milestoneCostNodeId.toString().split('*');
    if (widget.property.nodeId.value.startsWith(milestoneWildcardNodeId[0]) &&
        widget.property.nodeId.value.endsWith(milestoneWildcardNodeId[1])) {
      return true;
    }
    return false;
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
      labelText: schema.title.isEmpty ? null : schema.formattedTitle,
      placeholder: schema.placeholder,
      range: _numRangeToMoneyRange(schema.numRange),
      showHelper: widget.isEditMode,
      enabled: widget.isEditMode,
      ignorePointers: !widget.isEditMode,
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
      _controller = VoicesMoneyFieldController(
        currency: newSchema.currency,
        moneyUnits: newSchema.moneyUnits,
        value: _valueToMoney(newValue),
      );
    } else if (oldValue != newValue) {
      _controller.money = _valueToMoney(newValue);
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

    _controller = VoicesMoneyFieldController(
      currency: widget.schema.currency,
      moneyUnits: widget.schema.moneyUnits,
      value: _valueToMoney(widget.property.value ?? widget.schema.defaultValue),
    );
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  int? _moneyToValue(Money? money) {
    if (money == null) {
      return null;
    }

    return widget.schema.moneyToValue(money);
  }

  OpenRange<Money>? _numRangeToMoneyRange(NumRange<int>? range) {
    if (range == null) {
      return null;
    }

    return OpenRange(
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
