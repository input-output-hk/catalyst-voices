import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/input_formatters.dart';
import 'package:catalyst_voices/widgets/rich_text/insert_new_image_dialog_body.dart';
import 'package:catalyst_voices/widgets/rich_text/insert_new_image_dialog_footer.dart';
import 'package:catalyst_voices/widgets/rich_text/insert_new_image_dialog_header.dart';
import 'package:flutter/material.dart';

class InsertNewImageDialog extends StatefulWidget {
  const InsertNewImageDialog({super.key});

  @override
  State<InsertNewImageDialog> createState() => _InsertNewImageDialogState();
}

class _InsertNewImageDialogState extends State<InsertNewImageDialog> {
  final _textController = TextEditingController();

  bool get _inputFieldIsEmpty => _url.isEmpty;

  bool get _isValidImageUrl =>
      _inputFieldIsEmpty || ImageUrlValidator.isValid(_url);

  String get _url => _textController.text.trim();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = context.colors;

    return Dialog(
      backgroundColor: colors.elevationsOnSurfaceNeutralLv1Grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: SizedBox(
        width: 450,
        child: ValueListenableBuilder(
          valueListenable: _textController,
          builder: (context, _, __) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InsertNewImageDialogHeader(),
                Divider(
                  color: colorScheme.outline,
                ),
                InsertNewImageDialogBody(
                  textController: _textController,
                  isValidImageUrl: _isValidImageUrl,
                  inputFieldIsEmpty: _inputFieldIsEmpty,
                  onSubmit: _onSubmit,
                ),
                Divider(
                  color: colorScheme.outline,
                ),
                InsertNewImageDialogFooter(
                  isValidImageUrl: _isValidImageUrl,
                  inputFieldIsEmpty: _inputFieldIsEmpty,
                  onInsertImage: _onSubmit,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    Navigator.pop(context, _url);
  }
}
