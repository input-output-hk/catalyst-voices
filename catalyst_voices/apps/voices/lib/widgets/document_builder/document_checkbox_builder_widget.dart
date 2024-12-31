import 'package:catalyst_voices/widgets/document_builder/document_property_footer.dart';
import 'package:catalyst_voices/widgets/document_builder/document_property_topbar.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentCheckboxBuilderWidget extends StatefulWidget {
  final bool? value;
  final AgreementConfirmationDefinition definition;
  final DocumentNodeId nodeId;
  final String description;
  final String title;
  final ValueChanged<DocumentChange> onChanged;

  const DocumentCheckboxBuilderWidget({
    super.key,
    required this.value,
    required this.definition,
    required this.nodeId,
    required this.description,
    required this.title,
    required this.onChanged,
  });

  @override
  State<DocumentCheckboxBuilderWidget> createState() =>
      _DocumentCheckboxBuilderWidgetState();
}

class _DocumentCheckboxBuilderWidgetState
    extends State<DocumentCheckboxBuilderWidget> {
  bool editMode = false;
  late bool initialValue;
  late bool currentEditValue;
  DocumentNodeId get nodeId => widget.nodeId;
  String get description => widget.description;
  bool get defaultValue => widget.definition.defaultValue;

  @override
  void initState() {
    super.initState();

    initialValue = widget.value ?? defaultValue;
    currentEditValue = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocumentPropertyTopbar(
              isEditMode: editMode,
              onToggleEditMode: _toggleEditMode,
              title: widget.title,
            ),
            const SizedBox(height: 22),
            if (description.isNotEmpty) ...[
              Text(
                description,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 22),
            ],
            VoicesCheckbox(
              value: currentEditValue,
              onChanged: _changeValue,
              isDisabled: !editMode,
              label: Text(
                context.l10n.agree,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: !editMode
                          ? Theme.of(context).colors.textDisabled
                          : null,
                    ),
              ),
            ),
            Offstage(
              offstage: !editMode,
              child: DocumentPropertyFooter(
                onSave: !_isValidValue ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _isValidValue => currentEditValue == widget.definition.constValue;

  void _toggleEditMode() {
    if (editMode) {
      currentEditValue = initialValue;
    }
    setState(() {
      editMode = !editMode;
    });
  }

  void _changeValue(bool value) {
    setState(() {
      currentEditValue = value;
    });
  }

  void _save() {
    widget.onChanged(
      DocumentChange(
        nodeId: nodeId,
        value: currentEditValue,
      ),
    );
    setState(() {
      editMode = false;
      initialValue = currentEditValue;
    });
  }
}
