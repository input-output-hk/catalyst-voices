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
  bool _isValidImageUrl = true;
  bool _inputFieldIsEmpty = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = context.colors;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        width: 450,
        height: 432,
        decoration: BoxDecoration(
          color: colors.elevationsOnSurfaceNeutralLv1Grey,
        ),
        child: Column(
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
            ),
            Divider(
              color: colorScheme.outline,
            ),
            InsertNewImageDialogFooter(
              isValidImageUrl: _isValidImageUrl,
              inputFieldIsEmpty: _inputFieldIsEmpty,
              onInserImage: () => Navigator.pop(context, _textController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      _validateUrl(_textController.text);
    });
  }

  void _validateUrl(String url) {
    setState(() {
      _inputFieldIsEmpty = url.trim().isEmpty;
      _isValidImageUrl = _inputFieldIsEmpty || ImageUrlValidator.isValid(url);
    });
  }
}
