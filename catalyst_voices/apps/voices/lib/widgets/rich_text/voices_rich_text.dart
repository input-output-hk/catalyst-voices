import 'package:catalyst_voices/widgets/rich_text/voices_rich_text_limit.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

final class VoicesRichTextController extends QuillController {
  VoicesRichTextController({
    required super.document,
    required super.selection,
  });
}

class VoicesRichText extends FormField<Document> {
  final VoicesRichTextController controller;
  final String title;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final int? charsLimit;

  VoicesRichText({
    super.key,
    super.enabled,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    required this.controller,
    required this.title,
    required this.focusNode,
    required this.scrollController,
    this.charsLimit,
    super.validator,
  }) : super(
          builder: (field) {
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
                  ),
                ),
                Offstage(
                  offstage: charsLimit == null,
                  child: VoicesRichTextLimit(
                    document: controller.document,
                    charsLimit: charsLimit,
                    errorMessage: field.errorText,
                  ),
                ),
              ],
            );
          },
        );
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
    return
        // TODO(jakub): enable after implementing https://github.com/input-output-hk/catalyst-voices/issues/846
        //   ResizableBoxParent(
        //   minHeight: 470,
        //   resizableVertically: true,
        //   resizableHorizontally: false,
        // child:
        DecoratedBox(
      decoration: BoxDecoration(
        color: isEditMode
            ? Theme.of(context).colors.onSurfaceNeutralOpaqueLv1
            : Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
        border: Border.all(
          color: _getBorderColor(context),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
    // ),
  }

  Color _getBorderColor(BuildContext context) {
    if (!isEditMode) {
      return Theme.of(context).colorScheme.outlineVariant;
    } else {
      if (isInvalid) {
        return Theme.of(context).colorScheme.error;
      }
      if (focusNode.hasFocus) {
        return Theme.of(context).colorScheme.primary;
      }
      return Theme.of(context).colorScheme.outlineVariant;
    }
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return QuillEditor(
      controller: controller,
      focusNode: focusNode,
      scrollController: scrollController,
      configurations: QuillEditorConfigurations(
        padding: const EdgeInsets.all(16),
        placeholder: context.l10n.placeholderRichText,
        customStyles: DefaultStyles(
          placeHolder: DefaultTextBlockStyle(
            textTheme.bodyLarge?.copyWith(color: theme.colors.textDisabled) ??
                DefaultTextStyle.of(context).style,
            HorizontalSpacing.zero,
            VerticalSpacing.zero,
            VerticalSpacing.zero,
            null,
          ),
        ),
        embedBuilders: CatalystPlatform.isWeb
            ? FlutterQuillEmbeds.editorWebBuilders()
            : FlutterQuillEmbeds.editorBuilders(),
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

extension on QuillController {
  bool get isHeaderSelected {
    return getSelectionStyle().attributes.containsKey('header');
  }
}
