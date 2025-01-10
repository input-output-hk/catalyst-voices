import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class AgreementConfirmationWidget extends StatefulWidget {
  final bool? value;
  final AgreementConfirmationDefinition definition;
  final DocumentNodeId nodeId;
  final String description;
  final String title;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const AgreementConfirmationWidget({
    super.key,
    required this.value,
    required this.definition,
    required this.nodeId,
    required this.description,
    required this.title,
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

  DocumentNodeId get _nodeId => widget.nodeId;

  MarkdownData get _description => MarkdownData(widget.description);

  bool get _defaultValue => widget.definition.defaultValue;

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

    if (oldWidget.value != widget.value) {
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
                  color: !widget.isEditMode
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

    widget.onChanged(
      DocumentValueChange(
        nodeId: _nodeId,
        value: _currentEditValue,
      ),
    );
  }

  void _setInitialValues() {
    _initialValue = widget.value ?? _defaultValue;
    _currentEditValue = _initialValue;
  }
}
