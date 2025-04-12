import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
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
  final VoidCallback onSave;
  final VoidCallback onOpenInEditor;

  const _ActionButtons({
    required this.onSave,
    required this.onOpenInEditor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          onTap: () {
            Navigator.of(context).pop();
            const DiscoveryRoute().go(context);
          },
          leading: VoicesAssets.icons.informationCircle.buildIcon(),
          child: Text(context.l10n.jumpToCampaignCategory),
        ),
        const Spacer(),
        BlocSelector<NewProposalCubit, NewProposalState, bool>(
          selector: (state) => state.isValid && !state.isCreatingProposal,
          builder: (context, canTap) {
            return VoicesTextButton(
              onTap: canTap ? onSave : null,
              child: Text(context.l10n.saveDraft),
            );
          },
        ),
        const SizedBox(width: 8),
        BlocSelector<NewProposalCubit, NewProposalState, bool>(
          selector: (state) => state.isValid && !state.isCreatingProposal,
          builder: (context, canTap) {
            return VoicesFilledButton(
              onTap: canTap ? onOpenInEditor : null,
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
        return SingleSelectDropdown<SignedDocumentRef>(
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewProposalCubit, NewProposalState,
        ({bool isLoading, bool isMissingProposerRole})>(
      selector: (state) => (
        isLoading: state.isLoading,
        isMissingProposerRole: state.isMissingProposerRole
      ),
      builder: (context, state) {
        if (state.isLoading) {
          return const _LoadingContent();
        } else if (state.isMissingProposerRole) {
          return const _MissingProposerRoleContent();
        } else {
          return const _CreateNewProposalContent();
        }
      },
    );
  }
}

class _CreateNewProposalContent extends StatefulWidget {
  const _CreateNewProposalContent();

  @override
  State<_CreateNewProposalContent> createState() =>
      _CreateNewProposalContentState();
}

class _CreateNewProposalContentState extends State<_CreateNewProposalContent> {
  final FocusNode _categoryFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
          _ActionButtons(
            onSave: _onSave,
            onOpenInEditor: _onOpenInEditor,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _categoryFocusNode.dispose();
    super.dispose();
  }

  void onTitleSubmitted(String title) {
    _categoryFocusNode.requestFocus();
  }

  Future<void> _onOpenInEditor() async {
    final cubit = context.read<NewProposalCubit>();
    final draftRef = await cubit.createDraft();
    if (draftRef != null && mounted) {
      ProposalBuilderRoute.fromRef(ref: draftRef).go(context);
    }
  }

  Future<void> _onSave() async {
    final cubit = context.read<NewProposalCubit>();
    final draftRef = await cubit.createDraft();

    if (draftRef != null && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onTitleSubmitted(String title) {
    _categoryFocusNode.requestFocus();
  }
}

class _CreateNewProposalDialogState extends State<CreateNewProposalDialog>
    with ErrorHandlerStateMixin<NewProposalCubit, CreateNewProposalDialog> {
  @override
  Widget build(BuildContext context) {
    return VoicesDetailsDialog(
      constraints: const BoxConstraints(maxHeight: 390, maxWidth: 750),
      header: VoicesAlignTitleHeader(
        title: context.l10n.createProposal,
        padding: const EdgeInsets.all(24),
      ),
      body: const _Content(),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(context.read<NewProposalCubit>().load());
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: VoicesCircularProgressIndicator(),
    );
  }
}

class _MissingProposerRoleContent extends StatelessWidget {
  const _MissingProposerRoleContent();

  @override
  Widget build(BuildContext context) {
    // TODO(dtscalac): implement it when design is available
    return const Placeholder();
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
