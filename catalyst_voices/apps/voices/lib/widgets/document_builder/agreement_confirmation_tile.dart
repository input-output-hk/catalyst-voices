import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/document_builder/common/document_property_footer.dart';
import 'package:catalyst_voices/widgets/document_builder/common/document_property_topbar.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreementConfirmationTile extends StatefulWidget {
  final bool? value;
  final AgreementConfirmationDefinition definition;
  final DocumentNodeId nodeId;
  final String description;
  final String title;
  final bool isSelected;
  final ValueChanged<DocumentChange> onChanged;

  const AgreementConfirmationTile({
    super.key,
    required this.value,
    required this.definition,
    required this.nodeId,
    required this.description,
    required this.title,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  State<AgreementConfirmationTile> createState() =>
      _DocumentCheckboxBuilderWidgetState();
}

class _DocumentCheckboxBuilderWidgetState
    extends State<AgreementConfirmationTile> {
  bool editMode = false;
  late bool initialValue;
  late bool currentEditValue;
  DocumentNodeId get nodeId => widget.nodeId;
  String get description => widget.description;
  bool get defaultValue => widget.definition.defaultValue;

  @override
  void initState() {
    super.initState();

    _setInitialValues();
  }

  @override
  void didUpdateWidget(covariant AgreementConfirmationTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _setInitialValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableTile(
      isSelected: widget.isSelected,
      child: DecoratedBox(
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
                MarkdownBody(
                  data: description,
                  selectable: true,
                  onTapLink: (text, href, title) async {
                    if (href == null) return;
                    final url = href.getUri();
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
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

  void _setInitialValues() {
    initialValue = widget.value ?? defaultValue;
    currentEditValue = initialValue;
  }
}
