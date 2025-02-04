import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class AgreementConfirmationWidget extends StatefulWidget {
  final DocumentValueProperty<bool> property;
  final DocumentAgreementConfirmationSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const AgreementConfirmationWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<AgreementConfirmationWidget> createState() =>
      _DocumentCheckboxBuilderWidgetState();
}

class _DocumentCheckboxBuilderWidgetState
    extends State<AgreementConfirmationWidget> {
  late bool _initialValue;
  late bool _currentEditValue;

  DocumentNodeId get _nodeId => widget.schema.nodeId;

  MarkdownData get _description =>
      widget.schema.description ?? MarkdownData.empty;

  bool get _defaultValue => widget.schema.defaultValue ?? false;

  @override
  void initState() {
    super.initState();

    _setInitialValues();
  }

  @override
  void didUpdateWidget(covariant AgreementConfirmationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode && !widget.isEditMode) {
      _currentEditValue = _initialValue;
    }

    if (oldWidget.property.value != widget.property.value) {
      _setInitialValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_description.data.isNotEmpty) ...[
          MarkdownText(
            _description,
          ),
          const SizedBox(height: 22),
        ],
        VoicesCheckbox(
          value: _currentEditValue,
          onChanged: _changeValue,
          isDisabled: !widget.isEditMode,
          label: Text(
            context.l10n.agree,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: !widget.isEditMode && !_currentEditValue
                      ? Theme.of(context).colors.textDisabled
                      : null,
                ),
          ),
        ),
      ],
    );
  }

  void _changeValue(bool value) {
    _initialValue = _currentEditValue;
    setState(() {
      _currentEditValue = value;
    });

    final change = DocumentValueChange(
      nodeId: _nodeId,
      value: _currentEditValue,
    );

    widget.onChanged([change]);
  }

  void _setInitialValues() {
    _initialValue = widget.property.value ?? _defaultValue;
    _currentEditValue = _initialValue;
  }
}
