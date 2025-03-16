import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _SelectedCategoryData = ({
  List<CampaignCategoryDetailsViewModel> categories,
  SignedDocumentRef? value,
});

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
            _SectionTitle(
              text: context.l10n.title.starred(),
            ),
            const _TitleTextField(),
            const SizedBox(height: 16),
            _SectionTitle(
              text: context.l10n.selectedCategory.starred(),
            ),
            const _CategorySelection(),
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
          onTap: () {
            const DiscoveryRoute().go(context);
          },
          leading: VoicesAssets.icons.informationCircle.buildIcon(),
          child: Text(context.l10n.jumpToCampaignCategory),
        ),
        const Spacer(),
        BlocSelector<NewProposalCubit, NewProposalState, bool>(
          selector: (state) {
            return state.isValid;
          },
          builder: (context, isValid) {
            return VoicesTextButton(
              onTap: isValid
                  ? () {
                      // TODO(dtscalac): save new draft
                    }
                  : null,
              child: Text(context.l10n.saveDraft),
            );
          },
        ),
        const SizedBox(width: 8),
        BlocSelector<NewProposalCubit, NewProposalState, bool>(
          selector: (state) {
            return state.isValid;
          },
          builder: (context, isValid) {
            return VoicesFilledButton(
              onTap: isValid
                  ? () {
                      // ignore: unused_local_variable
                      final title =
                          context.read<NewProposalCubit>().state.title;
                      // ignore: unused_local_variable
                      final categoryId =
                          context.read<NewProposalCubit>().state.categoryId;
                      // TODO(dtscalac): create new proposal and open in editor
                    }
                  : null,
              child: Text(context.l10n.openInEditor),
            );
          },
        ),
      ],
    );
  }
}

class _CategorySelection extends StatelessWidget {
  const _CategorySelection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewProposalCubit, NewProposalState,
        _SelectedCategoryData>(
      selector: (state) {
        return (
          categories: state.categories,
          value: state.categoryId,
        );
      },
      builder: (context, state) {
        return SingleSelectDropdown<SignedDocumentRef>(
          filled: false,
          borderRadius: 8,
          items: state.categories
              .map(
                (e) => DropdownMenuEntry(
                  value: e.id,
                  label: e.formattedName,
                ),
              )
              .toList(),
          value: state.value,
          onChanged: (value) {
            context.read<NewProposalCubit>().updateSelectedCategory(value);
          },
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleSmall,
    );
  }
}

class _TitleTextField extends StatelessWidget {
  const _TitleTextField();

  @override
  Widget build(BuildContext context) {
    return VoicesTextField(
      onFieldSubmitted: (_) {},
      onChanged: (value) => context.read<NewProposalCubit>().updateTitle(value),
      decoration: VoicesTextFieldDecoration(
        borderRadius: BorderRadius.circular(8),
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.colors.outlineBorder),
        ),
        helperText: context.l10n.required.starred().toLowerCase(),
      ),
    );
  }
}
