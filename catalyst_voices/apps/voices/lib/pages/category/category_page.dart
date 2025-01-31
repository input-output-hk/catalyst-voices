import 'dart:async';

import 'package:catalyst_voices/pages/category/category_detail_view.dart';
import 'package:catalyst_voices/widgets/cards/category_proposals_details_card.dart';
import 'package:catalyst_voices/widgets/cards/create_proposal_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
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
    unawaited(_handleInitialValue());
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
        child: BlocBuilder<CategoryDetailCubit, CategoryDetailState>(
          builder: (context, state) {
            return switch (state) {
              final CategoryDetailData state => _Body(
                  category: state.category,
                ),
              final CategoryDetailError state => Center(
                  child: VoicesErrorIndicator(
                    message: state.error.message(context),
                    onRetry: () async {
                      await context
                          .read<CategoryDetailCubit>()
                          .getCategoryDetail(widget.categoryId);
                    },
                  ),
                ),
              final CategoryDetailLoading _ => _Body(
                  category: CampaignCategoryViewModel.dummy(),
                  isLoading: true,
                ),
            };
          },
        ),
      ),
    );
  }

  Future<void> _handleInitialValue() async {
    final discoveryCategory =
        context.read<DiscoveryCubit>().localCategory(widget.categoryId);
    if (discoveryCategory != null) {
      context.read<CategoryDetailCubit>().loadCategoryDetail(discoveryCategory);
    } else {
      await context
          .read<CategoryDetailCubit>()
          .getCategoryDetail(widget.categoryId);
    }
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
