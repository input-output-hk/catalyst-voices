import 'package:catalyst_voices/widgets/document_builder/document_property_footer.dart';
import 'package:catalyst_voices/widgets/document_builder/document_property_topbar.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentCheckboxBuilderWidget extends StatefulWidget {
  final DocumentProperty property;
  final ValueChanged<DocumentChange> onChanged;

  const DocumentCheckboxBuilderWidget({
    super.key,
    required this.property,
    required this.onChanged,
  });

  @override
  State<DocumentCheckboxBuilderWidget> createState() =>
      _DocumentCheckboxBuilderWidgetState();
}

class _DocumentCheckboxBuilderWidgetState
    extends State<DocumentCheckboxBuilderWidget> {
  bool editMode = false;
  late bool value;
  late bool initialValue;
  DocumentNodeId get nodeId => widget.property.schema.nodeId;
  String get description => widget.property.schema.description ?? '';
  AgreementConfirmationDefinition get definition =>
      widget.property.schema.definition as AgreementConfirmationDefinition;

  @override
  void initState() {
    super.initState();

    value = bool.tryParse(widget.property.value.toString()) ??
        bool.tryParse(widget.property.schema.defaultValue.toString()) ??
        false;
    initialValue = value;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocumentPropertyTopbar(
              isEditMode: editMode,
              onToggleEditMode: _toggleEditMode,
              title: widget.property.schema.title,
            ),
            const SizedBox(height: 22),
            Offstage(
              offstage: description.isEmpty,
              child: Text(
                description,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 22),
            VoicesCheckbox(
              value: value,
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
                onSave: !_isValidValue
                    ? null
                    : () {
                        widget.onChanged(
                          DocumentChange(
                            nodeId: nodeId,
                            value: value,
                          ),
                        );
                        setState(() {
                          editMode = false;
                          initialValue = value;
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleEditMode() {
    if (editMode) {
      value = initialValue;
    }
    setState(() {
      editMode = !editMode;
    });
  }

  void _changeValue(bool value) {
    setState(() {
      this.value = value;
    });
  }

  bool get _isValidValue => value == definition.constValue;
}
