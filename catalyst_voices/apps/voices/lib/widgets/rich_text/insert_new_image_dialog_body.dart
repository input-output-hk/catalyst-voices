import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InsertNewImageDialogBody extends StatelessWidget {
  final TextEditingController textController;
  final bool isValidImageUrl;
  final bool inputFieldIsEmpty;

  const InsertNewImageDialogBody({
    required this.textController,
    required this.isValidImageUrl,
    required this.inputFieldIsEmpty,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.insertNewImageDialogImageUrl,
            style: textTheme.titleSmall?.copyWith(
              color: colors.textOnPrimaryLevel0,
            ),
          ),
          const SizedBox(height: 4),
          VoicesTextField(
            controller: textController,
            decoration: VoicesTextFieldDecoration(
              hintText: l10n.insertNewImageDialogTextPlaceholder,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              fillColor: colorScheme.surface,
              errorText: !inputFieldIsEmpty && !isValidImageUrl
                  ? l10n.insertNewImageDialogInvalidUrl
                  : null,
            ),
            keyboardType: TextInputType.text,
            onFieldSubmitted: (_) {},
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
                      // TODO(minikin): Open knowledge base link
                    },
                    child: Text(
                      l10n.knowledgeBase,
                      style: textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                        color: colorScheme.primary,
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
        ],
      ),
    );
  }
}
