import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text_limit.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

typedef CanEditDocumentGetter = bool Function(Document document);

bool _alwaysAllowEdit(Document document) => true;

final class VoicesRichTextController extends QuillController {
  VoicesRichTextController({
    required super.document,
    required super.selection,
  });
}

final class VoicesRichTextEditModeController extends ValueNotifier<bool> {
  //ignore: avoid_positional_boolean_parameters
  VoicesRichTextEditModeController([super.value = false]);
}

/// A component for rich text writing
/// using Quill under the hood
/// https://pub.dev/packages/flutter_quill
class VoicesRichText extends StatefulWidget {
  final String title;
  final VoicesRichTextController? controller;
  final VoicesRichTextEditModeController? editModeController;
  final FocusNode? focusNode;
  final int? charsLimit;
  final CanEditDocumentGetter canEditDocumentGetter;
  final VoidCallback? onEditBlocked;
  final ValueChanged<Document>? onSaved;

  const VoicesRichText({
    super.key,
    this.title = '',
    this.controller,
    this.editModeController,
    this.focusNode,
    this.charsLimit,
    this.canEditDocumentGetter = _alwaysAllowEdit,
    this.onEditBlocked,
    this.onSaved,
  });

  @override
  State<VoicesRichText> createState() => _VoicesRichTextState();
}

class _VoicesRichTextState extends State<VoicesRichText> {
  VoicesRichTextController? _controller;

  VoicesRichTextController get _effectiveController {
    return widget.controller ??
        (_controller ??= VoicesRichTextController(
          document: Document(),
          selection: const TextSelection.collapsed(offset: 0),
        ));
  }

  VoicesRichTextEditModeController? _editModeController;

  VoicesRichTextEditModeController get _effectiveEditModeController {
    return widget.editModeController ??
        (_editModeController ??= VoicesRichTextEditModeController());
  }

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode {
    return widget.focusNode ??
        (_focusNode ??= FocusNode(
          canRequestFocus: _effectiveEditModeController.value,
        ));
  }

  ScrollController? _scrollController;

  ScrollController get _effectiveScrollController {
    return (_scrollController ??= ScrollController());
  }

  Document? _observedDocument;
  StreamSubscription<DocChange>? _documentChangeSub;

  Document? _preEditDocument;

  @override
  void initState() {
    super.initState();

    _effectiveController.addListener(_onControllerChanged);
    _effectiveEditModeController.addListener(_onEditModeControllerChanged);

    _updateObservedDocument();
  }

  @override
  void didUpdateWidget(covariant VoicesRichText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      _controller = VoicesRichTextController(
        document: oldWidget.controller!.document,
        selection: oldWidget.controller!.selection,
      );
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller?.removeListener(_onControllerChanged);
      _controller?.dispose();
      _controller = null;
    }

    if (widget.controller != oldWidget.controller) {
      final old = oldWidget.controller ?? _controller;
      final current = widget.controller ?? _controller;

      old?.removeListener(_onControllerChanged);
      current?.addListener(_onControllerChanged);

      _updateObservedDocument();
    }

    if (widget.editModeController != oldWidget.editModeController) {
      final old = oldWidget.editModeController ?? _editModeController;
      final current = widget.editModeController ?? _editModeController;

      old?.removeListener(_onEditModeControllerChanged);
      current?.addListener(_onEditModeControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    _editModeController?.dispose();
    _editModeController = null;

    _focusNode?.dispose();
    _focusNode = null;

    _scrollController?.dispose();
    _scrollController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charsLimit = widget.charsLimit;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 20, bottom: 20),
          child: _TopBar(
            title: widget.title,
            isEditMode: _effectiveEditModeController.value,
            onToggleEditMode: _toggleEditMode,
          ),
        ),
        Offstage(
          offstage: !_effectiveEditModeController.value,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _Toolbar(controller: _effectiveController),
          ),
        ),
        _EditorDecoration(
          isEditMode: _effectiveEditModeController.value,
          child: _Editor(
            controller: _effectiveController,
            focusNode: _effectiveFocusNode,
            scrollController: _effectiveScrollController,
          ),
        ),
        Offstage(
          offstage: charsLimit == null,
          child: VoicesRichTextLimit(
            document: _effectiveController.document,
            charsLimit: charsLimit,
          ),
        ),
        const SizedBox(height: 16),
        Offstage(
          offstage: !_effectiveEditModeController.value,
          child: _Footer(
            onSave: _saveDocument,
          ),
        ),
        if (!_effectiveEditModeController.value) const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _toggleEditMode() async {
    if (!_effectiveEditModeController.value) {
      if (!widget.canEditDocumentGetter(_effectiveController.document)) {
        widget.onEditBlocked?.call();
        return;
      }
    }

    if (_effectiveEditModeController.value) {
      _stopEdit();
    } else {
      _startEdit();
    }
  }

  void _saveDocument() {
    _preEditDocument = null;
    _effectiveEditModeController.value = false;

    widget.onSaved?.call(_effectiveController.document);
  }

  void _startEdit() {
    final currentDocument = _effectiveController.document;
    _preEditDocument = Document.fromDelta(currentDocument.toDelta());
    _effectiveEditModeController.value = true;
  }

  void _stopEdit() {
    final preEditDocument = _preEditDocument;
    _preEditDocument = null;
    _effectiveEditModeController.value = false;

    if (preEditDocument != null) {
      _effectiveController.document = preEditDocument;
    }
  }

  void _onControllerChanged() {
    if (_observedDocument != _effectiveController.document) {
      _updateObservedDocument();
    }
  }

  void _onEditModeControllerChanged() {
    setState(() {
      _effectiveFocusNode.canRequestFocus = _effectiveEditModeController.value;
    });
  }

  void _onDocumentChanged(DocChange change) {
    _enforceChatLimit();
  }

  void _updateObservedDocument() {
    _observedDocument = _effectiveController.document;
    unawaited(_documentChangeSub?.cancel());
    _documentChangeSub = _observedDocument?.changes.listen(_onDocumentChanged);
  }

  void _enforceChatLimit() {
    final charsLimit = widget.charsLimit;
    if (charsLimit != null) {
      _clipDocument(charsLimit);
    }
  }

  void _clipDocument(int limit) {
    final documentLength = _effectiveController.document.length;
    final latestIndex = limit - 1;

    _effectiveController.replaceText(
      latestIndex,
      documentLength - limit,
      '',
      TextSelection.collapsed(offset: latestIndex),
    );
  }
}

class _EditorDecoration extends StatelessWidget {
  final bool isEditMode;
  final Widget child;

  const _EditorDecoration({
    required this.isEditMode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // TODO(jakub): enable after implementing https://github.com/input-output-hk/catalyst-voices/issues/846
      // child: ResizableBoxParent(
      //   minHeight: 470,
      //   resizableVertically: true,
      //   resizableHorizontally: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isEditMode
              ? Theme.of(context).colors.onSurfaceNeutralOpaqueLv1
              : Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IgnorePointer(
          ignoring: !isEditMode,
          child: child,
        ),
      ),
      // ),
    );
  }
}

class _Editor extends StatelessWidget {
  final VoicesRichTextController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;

  const _Editor({
    required this.controller,
    required this.focusNode,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      controller: controller,
      focusNode: focusNode,
      scrollController: scrollController,
      configurations: QuillEditorConfigurations(
        padding: const EdgeInsets.all(16),
        placeholder: context.l10n.placeholderRichText,
        embedBuilders: CatalystPlatform.isWeb
            ? FlutterQuillEmbeds.editorWebBuilders()
            : FlutterQuillEmbeds.editorBuilders(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback? onSave;

  const _Footer({
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      alignment: Alignment.centerRight,
      color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
      child: VoicesFilledButton(
        onTap: onSave,
        child: Text(context.l10n.saveButtonText.toUpperCase()),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final QuillController controller;

  const _Toolbar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: QuillToolbar(
        configurations: const QuillToolbarConfigurations(),
        child: Row(
          children: [
            QuillToolbarIconButton(
              tooltip: context.l10n.headerTooltipText,
              onPressed: () {
                if (controller.isHeaderSelected) {
                  controller.formatSelection(Attribute.header);
                } else {
                  controller.formatSelection(Attribute.h1);
                }
              },
              icon: VoicesAssets.icons.rtHeading.buildIcon(),
              isSelected: controller.isHeaderSelected,
              iconTheme: null,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtBold,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.bold,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtItalic,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.italic,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtOrderedList,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.ol,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtUnorderedList,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.ul,
            ),
            QuillToolbarIndentButton(
              options: QuillToolbarIndentButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtIncreaseIndent,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              isIncrease: true,
            ),
            QuillToolbarIndentButton(
              options: QuillToolbarIndentButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtDecreaseIndent,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              isIncrease: false,
            ),
            QuillToolbarImageButton(
              options: QuillToolbarImageButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.photograph,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  final SvgGenImage icon;
  final VoidCallback? onPressed;

  const _ToolbarIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon.buildIcon(),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final bool isEditMode;
  final VoidCallback? onToggleEditMode;

  const _TopBar({
    required this.title,
    required this.isEditMode,
    this.onToggleEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        VoicesTextButton(
          onTap: onToggleEditMode,
          child: Text(
            isEditMode
                ? context.l10n.cancelButtonText
                : context.l10n.editButtonText,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

extension on QuillController {
  bool get isHeaderSelected {
    return getSelectionStyle().attributes.containsKey('header');
  }
}
