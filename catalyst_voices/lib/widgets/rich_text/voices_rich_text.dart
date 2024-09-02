import 'dart:math';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

/// A component for rich text writing
/// using Quill under the hood
/// https://pub.dev/packages/flutter_quill
class VoicesRichText extends StatefulWidget {
  const VoicesRichText({
    super.key,
    this.charsLimit,
  });

  final int? charsLimit;

  @override
  State<VoicesRichText> createState() => _VoicesRichTextState();
}

class _VoicesRichTextState extends State<VoicesRichText> {
  final QuillController _controller = QuillController.basic();

  void _onDocumentChange(DocChange docChange) {
    final documentLength = _controller.document.length;
    final limit = widget.charsLimit;

    if (limit == null) return;

    if (documentLength > limit) {
      final latestIndex = limit - 1;
      _controller.replaceText(
        latestIndex,
        documentLength - limit,
        '',
        TextSelection.collapsed(offset: latestIndex),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.document.changes.listen(_onDocumentChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar(
          configurations: const QuillToolbarConfigurations(),
          child: Row(
            children: [
              QuillToolbarIconButton(
                tooltip: 'Header',
                onPressed: () {
                  if (_controller.getSelectionStyle().attributes['header'] ==
                      null) {
                    _controller.formatSelection(Attribute.h1);
                  } else {
                    _controller.formatSelection(Attribute.header);
                  }
                },
                icon: Text('H'),
                isSelected:
                    _controller.getSelectionStyle().attributes['header'] !=
                        null,
                iconTheme: null,
              ),
              QuillToolbarSelectHeaderStyleDropdownButton(
                controller: _controller,
              ),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: _controller,
                attribute: Attribute.bold,
              ),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: _controller,
                attribute: Attribute.italic,
              ),
              QuillToolbarToggleStyleButton(
                controller: _controller,
                attribute: Attribute.ol,
              ),
              QuillToolbarToggleStyleButton(
                controller: _controller,
                attribute: Attribute.ul,
                //options: QuillToolbarToggleStyleButtonOptions(iconData: Icons.abc),
              ),
              QuillToolbarIndentButton(
                controller: _controller,
                isIncrease: true,
              ),
              QuillToolbarIndentButton(
                controller: _controller,
                isIncrease: false,
              ),
              QuillToolbarImageButton(
                controller: _controller,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _ResizableBoxParent(
            resizable: true,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: QuillEditor.basic(
                controller: _controller,
                configurations: QuillEditorConfigurations(
                  padding: const EdgeInsets.all(16),
                  placeholder: 'Start writing your text...',
                  embedBuilders: FlutterQuillEmbeds.editorWebBuilders(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResizableBoxParent extends StatelessWidget {
  final bool resizable;
  final Widget child;

  const _ResizableBoxParent({
    required this.resizable,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!resizable) {
      return child;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _ResizableBox(
          constraints: constraints,
          child: child,
        );
      },
    );
  }
}

class _ResizableBox extends StatefulWidget {
  final BoxConstraints constraints;
  final Widget child;

  const _ResizableBox({
    required this.constraints,
    required this.child,
  });

  @override
  State<_ResizableBox> createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<_ResizableBox> {
  static const double _minWidth = 40;
  static const double _minHeight = 320;

  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();

    _width = widget.constraints.maxWidth != double.infinity
        ? widget.constraints.maxWidth
        : widget.constraints.constrainWidth(_minWidth);

    _height = max(widget.constraints.minHeight, _minHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: _width,
          height: _height,
          child: widget.child,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDownRight,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _width = (_width + details.delta.dx).clamp(
                    _minWidth,
                    widget.constraints.maxWidth,
                  );

                  _height = (_height + details.delta.dy).clamp(
                    _minHeight,
                    widget.constraints.maxHeight,
                  );
                });
              },
              child: VoicesAssets.images.dragger.buildIcon(size: 15),
            ),
          ),
        ),
      ],
    );
  }
}
