import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class CreateNewProposalDialog extends StatelessWidget {
  const CreateNewProposalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesDetailsDialog(
      constraints: const BoxConstraints(maxHeight: 390, maxWidth: 750),
      header: VoicesAlignTitleHeader(
        title: context.l10n.createProposal,
        padding: const EdgeInsets.all(24),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          16,
          24,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.title.starred()),
            VoicesTextField(
              onFieldSubmitted: (_) {},
              decoration: VoicesTextFieldDecoration(
                borderRadius: BorderRadius.circular(8),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.colors.outlineBorder),
                ),
                helperText: context.l10n.required.starred(),
              ),
            ),
            const SizedBox(height: 16),
            Text(context.l10n.selectedCategory.starred()),
            SingleSelectDropdown<String>(
              filled: false,
              borderRadius: 8,
              items: const [
                DropdownMenuEntry(
                  value: '1',
                  label: '1',
                ),
                DropdownMenuEntry(value: '2', label: '2'),
                DropdownMenuEntry(value: '3', label: '3'),
                DropdownMenuEntry(value: '4', label: '4'),
                DropdownMenuEntry(value: '5', label: '5'),
                DropdownMenuEntry(value: '6', label: '6'),
                DropdownMenuEntry(value: '7', label: '7'),
                DropdownMenuEntry(value: '8', label: '8'),
                DropdownMenuEntry(value: '9', label: '9'),
                DropdownMenuEntry(value: '10', label: '10'),
              ],
              value: '1',
              onChanged: (_) {},
            ),
            const SizedBox(height: 40),
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }

  static Future<void> show(BuildContext context) async {
    final result = showDialog<void>(
      context: context,
      routeSettings: const RouteSettings(name: '/create-new-proposal'),
      builder: (context) => const CreateNewProposalDialog(),
    );

    return result;
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          onTap: () {},
          leading: VoicesAssets.icons.informationCircle.buildIcon(),
          child: Text(context.l10n.jumpToCampaignCategory),
        ),
        const Spacer(),
        VoicesTextButton(
          child: Text(context.l10n.saveDraft),
        ),
        const SizedBox(width: 8),
        VoicesFilledButton(
          child: Text(context.l10n.openInEditor),
        ),
      ],
    );
  }
}
