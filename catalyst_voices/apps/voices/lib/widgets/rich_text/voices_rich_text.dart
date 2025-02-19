import 'dart:async';

import 'package:catalyst_voices/common/codecs/markdown_codec.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text_limit.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text_rules.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill_internal.dart' as quill_int;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'
    as quill_ext;

class VoicesRichText extends VoicesFormField<MarkdownData> {
  final VoicesRichTextController controller;
  final String title;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final int? charsLimit;

  VoicesRichText({
    super.key,
    required super.onChanged,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.enabled,
    super.validator,
    required this.controller,
    required this.title,
    required this.focusNode,
    required this.scrollController,
    this.charsLimit,
  }) : super(
          value: controller.markdownData,
          builder: (field) {
            void onChangedHandler(MarkdownData? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Offstage(
                  offstage: !enabled,
                  child: _Toolbar(
                    controller: controller,
                  ),
                ),
                _Title(title: title),
                _EditorDecoration(
                  isEditMode: enabled,
                  isInvalid: field.hasError,
                  focusNode: focusNode,
                  child: _Editor(
                    controller: controller,
                    focusNode: focusNode,
                    scrollController: scrollController,
                    onChanged: onChangedHandler,
                  ),
                ),
                Offstage(
                  offstage: charsLimit == null && field.errorText == null,
                  child: VoicesRichTextLimit(
                    controller: controller,
                    enabled: enabled,
                    charsLimit: charsLimit,
                    errorMessage: field.errorText,
                  ),
                ),
              ],
            );
          },
        );
}

final class VoicesRichTextController extends quill.QuillController {
  final _customRules = const <quill_int.Rule>[AutoAlwaysExitBlockRule()];

  VoicesRichTextController({
    required super.document,
    required super.selection,
  }) {
    document.setCustomRules(_customRules);
  }

  factory VoicesRichTextController.fromMarkdown({
    required MarkdownData markdownData,
    required TextSelection selection,
  }) {
    final delta = markdown.encoder.convert(markdownData);
    final newDocument = quill.Document.fromDelta(delta);

    return VoicesRichTextController(
      document: newDocument,
      selection: selection,
    );
  }

  MarkdownData get markdownData {
    final document = this.document;
    if (document.isEmpty()) {
      return MarkdownData.empty;
    }

    final delta = document.toDelta();
    final markdownData = markdown.decoder.convert(delta);
    return markdownData;
  }

  set markdownData(MarkdownData newMarkdownData) {
    final oldMarkdown = markdownData;
    if (oldMarkdown == newMarkdownData) {
      // Don't update the document if the markdown representation didn't change.
      // When updating the document Quill removes blank lines which conflict
      // with a user trying to insert a blank line.
      return;
    } else if (newMarkdownData.data.isEmpty) {
      clear();
    } else {
      final delta = markdown.encoder.convert(newMarkdownData);
      document = quill.Document.fromDelta(delta);
    }
  }

  void clearFormattingFromSelection() {
    toggledStyle = const quill.Style();

    final markdownAttributes = [
      quill.Attribute.ul,
      quill.Attribute.ol,
      quill.Attribute.h1,
      quill.Attribute.h2,
      quill.Attribute.h3,
      quill.Attribute.h4,
      quill.Attribute.h5,
      quill.Attribute.h6,
      quill.Attribute.bold,
      quill.Attribute.italic,
    ];

    for (final attribute in markdownAttributes) {
      formatSelection(
        quill.Attribute.clone(attribute, null),
        shouldNotifyListeners: false,
      );
    }

    notifyListeners();
  }
}

class _Editor extends StatefulWidget {
  final VoicesRichTextController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final ValueChanged<MarkdownData?>? onChanged;

  const _Editor({
    required this.controller,
    required this.focusNode,
    required this.scrollController,
    required this.onChanged,
  });

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorDecoration extends StatelessWidget {
  final bool isEditMode;
  final bool isInvalid;
  final FocusNode focusNode;
  final Widget child;

  const _EditorDecoration({
    required this.isEditMode,
    required this.isInvalid,
    required this.focusNode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: focusNode,
      child: child,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: isEditMode
                ? Theme.of(context).colors.onSurfaceNeutralOpaqueLv1
                : Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
            border: Border.all(
              color: _getBorderColor(context, focusNode.hasFocus),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        );
      },
    );
  }

  Color _getBorderColor(BuildContext context, bool hasFocus) {
    if (!isEditMode) {
      return Theme.of(context).colorScheme.outlineVariant;
    } else if (isInvalid) {
      return Theme.of(context).colorScheme.error;
    } else if (hasFocus) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.outlineVariant;
    }
  }
}

class _EditorState extends State<_Editor> {
  late final FocusNode _keyboardListenerFocus;
  quill.Document? _observedDocument;
  StreamSubscription<quill.DocChange>? _documentChangeSub;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return KeyboardListener(
      focusNode: _keyboardListenerFocus,
      onKeyEvent: _onKeyEvent,
      child: quill.QuillEditor(
        controller: widget.controller,
        focusNode: widget.focusNode,
        scrollController: widget.scrollController,
        configurations: quill.QuillEditorConfigurations(
          padding: const EdgeInsets.all(16),
          placeholder: context.l10n.placeholderRichText,
          characterShortcutEvents: quill.standardCharactersShortcutEvents,
          /* cSpell:disable */
          spaceShortcutEvents: quill.standardSpaceShorcutEvents,
          /* cSpell:enable */
          customStyles: quill.DefaultStyles(
            placeHolder: quill.DefaultTextBlockStyle(
              textTheme.bodyLarge?.copyWith(color: theme.colors.textDisabled) ??
                  DefaultTextStyle.of(context).style,
              quill.HorizontalSpacing.zero,
              quill.VerticalSpacing.zero,
              quill.VerticalSpacing.zero,
              null,
            ),
          ),
          embedBuilders: CatalystPlatform.isWeb
              ? quill_ext.FlutterQuillEmbeds.editorWebBuilders()
              : quill_ext.FlutterQuillEmbeds.editorBuilders(),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(_Editor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
      _updateObservedDocument();
    }
  }

  @override
  void dispose() {
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _keyboardListenerFocus = FocusNode();
    widget.controller.addListener(_onControllerChanged);
    _updateObservedDocument();
  }

  void _onControllerChanged() {
    if (_observedDocument != widget.controller.document) {
      _updateObservedDocument();
    }
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        widget.controller.selection.end == 0) {
      // Cleanup the formatting from the selection.
      // By default quill will not remove the last bullet point (ordered/unordered),
      // here we are removing it manually after the user has removed everything
      // else and only this is remaining.
      widget.controller.clearFormattingFromSelection();
    }
  }

  void _updateObservedDocument() {
    unawaited(_documentChangeSub?.cancel());

    _observedDocument = widget.controller.document;
    _documentChangeSub = _observedDocument?.changes.listen((change) {
      final markdownData = widget.controller.markdownData;
      widget.onChanged?.call(markdownData);
    });
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final quill.QuillController controller;

  const _Toolbar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: quill.QuillToolbar(
        configurations: const quill.QuillToolbarConfigurations(),
        child: Row(
          children: [
            _ToolbarAttributeIconButton(
              controller: controller,
              icon: VoicesAssets.icons.rtHeading,
              attribute: quill.Attribute.h1,
            ),
            _ToolbarAttributeIconButton(
              controller: controller,
              icon: VoicesAssets.icons.rtBold,
              attribute: quill.Attribute.bold,
            ),
            _ToolbarAttributeIconButton(
              controller: controller,
              icon: VoicesAssets.icons.rtItalic,
              attribute: quill.Attribute.italic,
            ),
            _ToolbarAttributeIconButton(
              controller: controller,
              icon: VoicesAssets.icons.rtOrderedList,
              attribute: quill.Attribute.ol,
            ),
            _ToolbarAttributeIconButton(
              controller: controller,
              icon: VoicesAssets.icons.rtUnorderedList,
              attribute: quill.Attribute.ul,
            ),
            _ToolbarImageOptionButton(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarAttributeIconButton extends StatelessWidget {
  final quill.QuillController controller;
  final quill.Attribute<dynamic> attribute;
  final SvgGenImage icon;

  const _ToolbarAttributeIconButton({
    required this.controller,
    required this.attribute,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return quill.QuillToolbarToggleStyleButton(
      controller: controller,
      attribute: attribute,
      options: quill.QuillToolbarToggleStyleButtonOptions(
        childBuilder: (options, extraOptions) {
          return _ToolbarIconButton(
            icon: icon,
            tooltip: options.tooltip,
            isToggled: extraOptions.isToggled,
            onPressed: extraOptions.onPressed,
          );
        },
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  final SvgGenImage icon;
  final String? tooltip;
  final bool isToggled;
  final VoidCallback? onPressed;

  const _ToolbarIconButton({
    required this.icon,
    required this.tooltip,
    required this.isToggled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: icon.buildIcon(),
      color: isToggled ? Theme.of(context).colorScheme.primary : null,
    );
  }
}

class _ToolbarImageOptionButton extends StatelessWidget {
  final quill.QuillController controller;

  const _ToolbarImageOptionButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return quill_ext.QuillToolbarImageButton(
      controller: controller,
      options: quill_ext.QuillToolbarImageButtonOptions(
        childBuilder: (options, extraOptions) {
          return _ToolbarIconButton(
            icon: VoicesAssets.icons.photograph,
            tooltip: options.tooltip,
            isToggled: false,
            onPressed: extraOptions.onPressed,
          );
        },
      ),
    );
  }
}
