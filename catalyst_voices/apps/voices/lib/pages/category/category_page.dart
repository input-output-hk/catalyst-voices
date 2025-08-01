import 'dart:async';

import 'package:catalyst_voices/pages/category/category_detail_view.dart';
import 'package:catalyst_voices/widgets/cards/category_proposals_details_card.dart';
import 'package:catalyst_voices/widgets/cards/create_proposal_card.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_wide_screen_constrained.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

typedef _StateData = ({bool show, CampaignCategoryDetailsViewModel data});

typedef _StateError = ({bool show, LocalizedException? error});

class CategoryPage extends StatefulWidget {
  final SignedDocumentRef categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _Body extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;
  final bool isLoading;

  const _Body({
    required this.category,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: SelectionArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: CategoryDetailView(
                  category: category,
                ),
              ),
            ),
            const SizedBox(width: 48),
            _CardInformation(
              category: category,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInformation extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;

  const _CardInformation({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 300),
      child: ListView(
        padding: const EdgeInsets.only(top: 96, bottom: 42),
        children: [
          CategoryProposalsDetailsCard(
            categoryId: category.id,
            categoryName: category.formattedName,
            categoryProposalsCount: category.proposalsCount,
          ),
          const SizedBox(height: 16),
          BlocSelector<SessionCubit, SessionState, bool>(
            selector: (state) {
              final isProposer = state.account?.isProposer ?? false;
              return (isProposer && state.isActive);
            },
            builder: (context, state) {
              return Offstage(
                offstage: !state,
                child: CreateProposalCard(
                  categoryId: category.id,
                  categoryName: category.formattedName,
                  categoryDos: category.dos,
                  categoryDonts: category.donts,
                  submissionCloseDate: category.submissionCloseDate,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailErrorSelector extends StatelessWidget {
  final SignedDocumentRef categoryId;

  const _CategoryDetailErrorSelector({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState, _StateError>(
      selector: (state) {
        return (
          show: state.isLoading == false && state.error != null,
          error: state.error,
        );
      },
      builder: (context, state) {
        final error = state.error ?? const LocalizedUnknownException();
        return Offstage(
          offstage: !state.show,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: VoicesErrorIndicator(
                message: error.message(context),
                onRetry: error is LocalizedNotFoundException
                    ? null
                    : () {
                        unawaited(
                          context.read<CategoryDetailCubit>().getCategoryDetail(categoryId),
                        );
                      },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryDetailLoadingOrDataSelector extends StatelessWidget {
  const _CategoryDetailLoadingOrDataSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState, _StateData>(
      selector: (state) {
        return (
          show: state.isLoading,
          data: state.category ?? CampaignCategoryDetailsViewModel.dummy()
        );
      },
      builder: (context, state) {
        return _Body(
          category: state.data,
          isLoading: state.show,
        );
      },
    );
  }
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      xs: const EdgeInsets.symmetric(horizontal: 12),
      sm: const EdgeInsets.symmetric(horizontal: 20),
      md: const EdgeInsets.symmetric(horizontal: 120),
      lg: const EdgeInsets.symmetric(horizontal: 120),
      other: const EdgeInsets.symmetric(horizontal: 120),
      child: Stack(
        children: [
          const _CategoryDetailLoadingOrDataSelector(),
          _CategoryDetailErrorSelector(
            categoryId: widget.categoryId,
          ),
        ].constrainedDelegate(maxWidth: 1200),
      ),
    );
  }

  @override
  void didUpdateWidget(CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.categoryId != oldWidget.categoryId) {
      unawaited(
        context.read<CategoryDetailCubit>().getCategoryDetail(widget.categoryId),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    unawaited(context.read<CategoryDetailCubit>().getCategories());
    unawaited(
      context.read<CategoryDetailCubit>().getCategoryDetail(widget.categoryId),
    );
  }
}
