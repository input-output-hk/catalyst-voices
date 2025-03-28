import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InsertNewImageDialog extends StatefulWidget {
  const InsertNewImageDialog({super.key});

  @override
  State<InsertNewImageDialog> createState() => _InsertNewImageDialogState();
}

class _InsertNewImageDialogState extends State<InsertNewImageDialog> {
  final _textController = TextEditingController();
  bool isValidImageUrl = true;
  bool hasText = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const images = VoicesAssets.images;
    final colorScheme = Theme.of(context).colorScheme;
    final colors = context.colors;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        width: 450,
        height: 412,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.elevationsOnSurfaceNeutralLv1Grey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: images.insertImage.buildIcon(),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.insertNewImageDialogTitle,
                  style: textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.insertNewImageDialogDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.textOnPrimaryLevel1,
              ),
            ),
            const SizedBox(height: 16),
            Divider(
              color: colorScheme.outline,
            ),
            const SizedBox(height: 22),
            Text(
              l10n.insertNewImageDialogImageUrl,
              style: textTheme.titleSmall?.copyWith(
                color: colors.textOnPrimaryLevel0,
              ),
            ),
            const SizedBox(height: 4),
            VoicesTextField(
              controller: _textController,
              decoration: VoicesTextFieldDecoration(
                hintText: l10n.insertNewImageDialogTextPlaceholder,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                fillColor: colorScheme.surface,
              ),
              keyboardType: TextInputType.text,
              onFieldSubmitted: (value) {},
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary,
                ),
                children: [
                  TextSpan(
                    text: l10n.richTextEditorImageSupportInfo,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textOnPrimaryLevel1,
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(width: 4),
                  ),
                  WidgetSpan(
                    child: InkWell(
                      onTap: () {
                        // TODO: Open knowledge base link
                      },
                      child: Text(
                        l10n.knowledgeBase,
                        style: textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.underline,
                          color: colors.primaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(width: 4),
                  ),
                  TextSpan(
                    text: l10n.toLearnMore,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textOnPrimaryLevel1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Divider(
              color: colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancelButtonText),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isValidImageUrl
                      ? () => Navigator.pop(context, _textController.text)
                      : null,
                  child: Text(l10n.insertNewImageDialogInsert),
                ),
              ],
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

  void validateUrl(String url) {
    setState(() {
      hasText = url.trim().isNotEmpty;
      isValidImageUrl = true;
    });
  }
}
