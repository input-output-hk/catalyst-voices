import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _SelectedCategoryData = ({
  List<CampaignCategoryDetailsViewModel> categories,
  String? value,
});

class CreateNewProposalDialog extends StatefulWidget {
  const CreateNewProposalDialog({super.key});

  @override
  State<CreateNewProposalDialog> createState() =>
      _CreateNewProposalDialogState();

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
          selector: (state) => state.isValid,
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
          selector: (state) => state.isValid,
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
  final FocusNode focusNode;

  const _CategorySelection({required this.focusNode});

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
        return SingleSelectDropdown<String>(
          focusNode: focusNode,
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

class _CreateNewProposalDialogState extends State<CreateNewProposalDialog> {
  final FocusNode _categoryFocusNode = FocusNode();

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
            _TitleTextField(
              onFieldSubmitted: _onTitleSubmitted,
            ),
            const SizedBox(height: 16),
            _SectionTitle(
              text: context.l10n.selectedCategory.starred(),
            ),
            _CategorySelection(focusNode: _categoryFocusNode),
            const SizedBox(height: 40),
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _categoryFocusNode.dispose();
    super.dispose();
  }

  void _onTitleSubmitted(String title) {
    _categoryFocusNode.requestFocus();
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
  final ValueChanged<String> onFieldSubmitted;

  const _TitleTextField({required this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewProposalCubit, NewProposalState, ProposalTitle>(
      selector: (state) => state.title,
      builder: (context, title) {
        return VoicesTextField(
          initialText: title.value,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: (value) => context
              .read<NewProposalCubit>()
              .updateTitle(ProposalTitle.dirty(value ?? '')),
          decoration: VoicesTextFieldDecoration(
            borderRadius: BorderRadius.circular(8),
            filled: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colors.outlineBorder),
            ),
            errorText: title.displayError?.message(context),
            helperText: context.l10n.required.starred().toLowerCase(),
          ),
        );
      },
    );
  }
}
