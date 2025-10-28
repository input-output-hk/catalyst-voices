import 'dart:async';

import 'package:catalyst_voices/common/ext/active_fund_number_selector_ext.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/toggles/voices_checkbox.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateNewProposalActionButtons extends StatelessWidget {
  final ProposalCreationStep step;

  const CreateNewProposalActionButtons({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.colors.outlineBorderVariant,
          ),
        ),
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: switch (step) {
        CreateProposalWithPreselectedCategoryStep() => const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8,
          children: [
            Flexible(
              child: _AgreementCheckboxes(),
            ),
            _StartProposalButton(),
          ],
        ),
        CreateProposalWithoutPreselectedCategoryStep(:final stage)
            when stage == CreateProposalStage.selectCategory =>
          const Row(
            spacing: 8,
            children: [
              Flexible(
                child: _AgreementCheckboxes(),
              ),
              _BackButton(),
              _StartProposalButton(),
            ],
          ),
        CreateProposalWithoutPreselectedCategoryStep() => const Row(
          children: [
            Spacer(),
            _SelectCategoryButton(),
          ],
        ),
      },
    );
  }
}

class _AgreementCheckboxes extends StatelessWidget {
  const _AgreementCheckboxes();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesCheckbox(
          value: context.select<NewProposalCubit, bool>(
            (cubit) => cubit.state.isAgreeToCategoryCriteria,
          ),
          onChanged: (value) {
            context.read<NewProposalCubit>().updateAgreeToCategoryCriteria(value: value);
          },
          label: Text(
            context.l10n.agreementFitToCategoryCriteria,
          ),
        ),
        VoicesCheckbox(
          value: context.select<NewProposalCubit, bool>(
            (cubit) => cubit.state.isAgreeToNoFurtherCategoryChange,
          ),
          onChanged: (value) {
            context.read<NewProposalCubit>().updateAgreeToNoFurtherCategoryChange(value: value);
          },
          label: Text(
            context.l10n.agreementCantChangeCategory(context.activeCampaignFundNumber),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: () => context.read<NewProposalCubit>().updateTitleStage(),
      child: Text(context.l10n.back),
    );
  }
}

class _SelectCategoryButton extends StatelessWidget {
  const _SelectCategoryButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewProposalCubit, NewProposalState, bool>(
      selector: (state) {
        return state.title.isValid;
      },
      builder: (context, isValid) {
        return VoicesFilledButton(
          onTap: isValid ? () => _selectCategoryStage(context) : null,
          child: const Text('Next: Select Category'),
        );
      },
    );
  }

  void _selectCategoryStage(BuildContext context) {
    context.read<NewProposalCubit>().selectCategoryStage();
  }
}

class _StartProposalButton extends StatelessWidget {
  const _StartProposalButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewProposalCubit, NewProposalState, bool>(
      selector: (state) {
        return state.isValid;
      },
      builder: (context, isValid) {
        return VoicesFilledButton(
          onTap: isValid ? () => unawaited(_startNewProposal(context)) : null,
          child: Text(
            context.l10n.startProposal,
          ),
        );
      },
    );
  }

  Future<void> _startNewProposal(BuildContext context) async {
    final cubit = context.read<NewProposalCubit>();
    final draftRef = await cubit.createDraft();
    if (draftRef != null && context.mounted) {
      ProposalBuilderRoute.fromRef(ref: draftRef).go(context);
    }
  }
}
