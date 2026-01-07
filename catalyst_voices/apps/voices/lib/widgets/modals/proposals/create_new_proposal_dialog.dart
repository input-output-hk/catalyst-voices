import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/modals/proposals/create_new_proposal_action_buttons.dart';
import 'package:catalyst_voices/widgets/modals/proposals/create_new_proposal_category_selection.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// TODO(damian-molinski): this widget have to be refactored into smaller files.
class CreateNewProposalDialog extends StatefulWidget {
  final SignedDocumentRef? categoryRef;

  const CreateNewProposalDialog({super.key, this.categoryRef});

  @override
  State<CreateNewProposalDialog> createState() => _CreateNewProposalDialogState();

  static Future<void> show(
    BuildContext context, {
    SignedDocumentRef? categoryRef,
  }) async {
    final result = showDialog<void>(
      context: context,
      routeSettings: const RouteSettings(name: '/create-new-proposal'),
      builder: (context) => CreateNewProposalDialog(
        categoryRef: categoryRef,
      ),
    );

    return result;
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewProposalCubit, NewProposalState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return const _LoadingContent();
        } else {
          return BlocSelector<NewProposalCubit, NewProposalState, ProposalCreationStep>(
            selector: (state) => state.step,
            builder: (context, step) {
              return switch (step) {
                CreateProposalWithPreselectedCategoryStep() => _ContentView(
                  step: step,
                  child: const _ProposalTitle(),
                ),
                CreateProposalWithoutPreselectedCategoryStep(:final stage) => switch (stage) {
                  CreateProposalStage.setTitle => _ContentView(
                    step: step,
                    child: const _ProposalTitle(),
                  ),
                  CreateProposalStage.selectCategory => _ContentView(
                    step: step,
                    child: const _ProposalCategory(),
                  ),
                },
              };
            },
          );
        }
      },
    );
  }
}

class _ContentView extends StatelessWidget {
  final ProposalCreationStep step;
  final Widget child;

  const _ContentView({
    required this.step,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 6),
            child: child,
          ),
        ),
        CreateNewProposalActionButtons(step: step),
      ],
    );
  }
}

class _CreateNewProposalDialogState extends State<CreateNewProposalDialog>
    with ErrorHandlerStateMixin<NewProposalCubit, CreateNewProposalDialog> {
  @override
  Widget build(BuildContext context) {
    return VoicesDetailsDialog(
      constraints: const BoxConstraints.tightFor(height: 800, width: 1200),
      header: VoicesAlignTitleHeader(
        title: _getTitle(),
        titleStyle: context.textTheme.titleLarge,
        padding: const EdgeInsets.all(20),
      ),
      body: const _Content(),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(context.read<NewProposalCubit>().load(categoryRef: widget.categoryRef));
  }

  String _getTitle() {
    final categoryName = context.select<NewProposalCubit, String?>(
      (cubit) => cubit.state.selectedCategoryName,
    );

    if (categoryName == null) {
      return context.l10n.createProposal;
    } else {
      return context.l10n.createProposalInCategory(categoryName);
    }
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

class _ProposalCategory extends StatelessWidget {
  const _ProposalCategory();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 28,
      children: [
        _SectionTitle(
          text: context.l10n.selectCategory,
          description: context.l10n.categorySelectionDescription,
        ),
        BlocSelector<NewProposalCubit, NewProposalState, NewProposalStateCategories>(
          selector: (state) => state.categories,
          builder: (context, state) {
            return CreateNewProposalCategorySelection(
              categories: state,
              onCategorySelected: (value) =>
                  context.read<NewProposalCubit>().updateSelectedCategory(value),
            );
          },
        ),
      ],
    );
  }
}

class _ProposalTitle extends StatelessWidget {
  const _ProposalTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 28,
      children: [
        _SectionTitle(
          text: context.l10n.title,
          description: context.l10n.proposalTitleShortDescription,
        ),
        const _TitleTextField(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final String description;

  const _SectionTitle({
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          text,
          style: context.textTheme.titleSmall,
        ),
        Text(
          description,
          style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textOnPrimaryLevel1),
        ),
      ],
    );
  }
}

class _TitleTextField extends StatelessWidget {
  const _TitleTextField();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewProposalCubit, NewProposalState, ProposalTitle>(
      selector: (state) => state.title,
      builder: (context, title) {
        return VoicesTextField(
          initialText: title.value,
          onFieldSubmitted: (_) {},
          onChanged: (value) => context.read<NewProposalCubit>().updateTitle(value ?? ''),
          decoration: VoicesTextFieldDecoration(
            borderRadius: BorderRadius.circular(8),
            filled: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colors.outlineBorder),
            ),
            labelText: context.l10n.enterTitle.starred(),
            errorText: title.displayError?.message(context),
            helperText: context.l10n.required.starred().toLowerCase(),
          ),
          maxLength: title.titleLengthRange?.max,
          maxLengthEnforcement: MaxLengthEnforcement.none,
        );
      },
    );
  }
}
