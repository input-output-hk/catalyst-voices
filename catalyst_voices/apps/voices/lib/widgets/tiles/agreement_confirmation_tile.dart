import 'package:catalyst_voices/common/ext/string_ext.dart';
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
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const AgreementConfirmationTile({
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
  State<AgreementConfirmationTile> createState() =>
      _DocumentCheckboxBuilderWidgetState();
}

class _DocumentCheckboxBuilderWidgetState
    extends State<AgreementConfirmationTile> {
  late bool _initialValue;
  late bool _currentEditValue;

  DocumentNodeId get _nodeId => widget.nodeId;
  String get _description => widget.description;
  bool get _defaultValue => widget.definition.defaultValue;

  @override
  void initState() {
    super.initState();

    _setInitialValues();
  }

  @override
  void didUpdateWidget(covariant AgreementConfirmationTile oldWidget) {
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
            if (_description.isNotEmpty) ...[
              MarkdownBody(
                data: _description,
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
        ),
      ),
    );
  }

  void _changeValue(bool value) {
    _initialValue = _currentEditValue;
    setState(() {
      _currentEditValue = value;
    });

    widget.onChanged(
      DocumentChange(
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
