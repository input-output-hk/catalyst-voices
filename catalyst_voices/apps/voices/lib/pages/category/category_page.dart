import 'dart:async';

import 'package:catalyst_voices/pages/category/category_detail_view.dart';
import 'package:catalyst_voices/widgets/cards/category_proposals_details_card.dart';
import 'package:catalyst_voices/widgets/cards/create_proposal_card.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<CategoryDetailCubit>().getCategories());
    unawaited(
      context.read<CategoryDetailCubit>().getCategoryDetail(widget.categoryId),
    );
  }

  @override
  void didUpdateWidget(CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.categoryId != oldWidget.categoryId) {
      unawaited(
        context
            .read<CategoryDetailCubit>()
            .getCategoryDetail(widget.categoryId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsivePadding(
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
          ],
        ),
      ),
    );
  }
}

typedef _StateData = ({bool show, CampaignCategoryViewModel data});

class _CategoryDetailLoadingOrDataSelector extends StatelessWidget {
  const _CategoryDetailLoadingOrDataSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState, _StateData>(
      selector: (state) {
        return (
          show: state.isLoading || state.error != null,
          data: state.category ?? CampaignCategoryViewModel.dummy()
        );
      },
      builder: (context, state) {
        return _Body(
          category: CampaignCategoryViewModel.dummy(),
          isLoading: state.show,
        );
      },
    );
  }
}

typedef _StateError = ({bool show, LocalizedException? error});

class _CategoryDetailErrorSelector extends StatelessWidget {
  final String categoryId;
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
                onRetry: () async {
                  await context
                      .read<CategoryDetailCubit>()
                      .getCategoryDetail(categoryId);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final CampaignCategoryViewModel category;
  final bool isLoading;
  const _Body({
    required this.category,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CategoryDetailView(
              category: category,
            ),
          ),
          const SizedBox(width: 48),
          _CardInformation(
            category: category,
          ),
        ],
      ),
    );
  }
}

class _CardInformation extends StatelessWidget {
  final CampaignCategoryViewModel category;
  const _CardInformation({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 300),
      child: Column(
        children: [
          const SizedBox(height: 96),
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
                  categoryRequirements: category.requirements,
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
