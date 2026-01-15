import 'dart:async';

import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/proposal_submission_phase_aware.dart';
import 'package:catalyst_voices/pages/category/category_detail_view.dart';
import 'package:catalyst_voices/pages/category/draggable_sheet_category_information.dart';
import 'package:catalyst_voices/pages/category/widgets/card_information/card_information.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_wide_screen_constrained.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryPage extends StatefulWidget {
  final SignedDocumentRef categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _Body extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;
  final bool isLoading;
  final bool isActiveProposer;

  const _Body({
    required this.category,
    this.isLoading = false,
    this.isActiveProposer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120),
      child: Skeletonizer(
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
              CardInformation(
                category: category,
                isActiveProposer: isActiveProposer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodySmall extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;
  final bool isLoading;
  final bool isActiveProposer;

  const _BodySmall({
    required this.category,
    this.isLoading = false,
    this.isActiveProposer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: CategoryDetailView(
                category: category,
              ),
            ),
          ),
          DraggableSheetCategoryInformation(
            category: category,
            isActiveProposer: isActiveProposer,
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailContent extends StatelessWidget {
  const _CategoryDetailContent();

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): refactor it into single class object in category_detail_state.dart
    // and do not rely on context.select<SessionCubit> here.
    return BlocSelector<
      CategoryDetailCubit,
      CategoryDetailState,
      DataVisibilityState<CampaignCategoryDetailsViewModel>
    >(
      selector: (state) {
        return (
          show: state.isLoading,
          data: state.selectedCategoryDetails ?? CampaignCategoryDetailsViewModel.placeholder(),
        );
      },
      builder: (context, state) {
        final isActiveProposer = context.select<SessionCubit, bool>(
          (cubit) => cubit.state.isProposerUnlock,
        );
        return ResponsiveChildBuilder(
          sm: (_) => _BodySmall(
            category: state.data,
            isLoading: state.show,
            isActiveProposer: isActiveProposer,
          ),
          md: (_) => _Body(
            category: state.data,
            isLoading: state.show,
            isActiveProposer: isActiveProposer,
          ),
        );
      },
    );
  }
}

class _CategoryDetailError extends StatelessWidget {
  final SignedDocumentRef categoryId;

  const _CategoryDetailError({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState, ErrorVisibilityState>(
      selector: (state) {
        return (
          show: state.isLoading == false && state.error != null,
          data: state.error,
        );
      },
      builder: (context, state) {
        final error = state.data ?? const LocalizedUnknownException();
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

class _CategoryPageState extends State<CategoryPage>
    with SignalHandlerStateMixin<CategoryDetailCubit, CategoryDetailSignal, CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return ProposalSubmissionPhaseAware(
      activeChild: Stack(
        children: [
          const _CategoryDetailContent(),
          _CategoryDetailError(
            categoryId: widget.categoryId,
          ),
        ].constrainedDelegate(),
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
  void handleSignal(CategoryDetailSignal signal) {
    switch (signal) {
      case ChangeCategoryRefSignal():
        _onCategoryRefChanged(signal.categoryId);
    }
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CategoryDetailCubit>()
      ..watchActiveCampaignCategories()
      ..watchProposalSubmissionDeadline();
    unawaited(cubit.getCategoryDetail(widget.categoryId));
  }

  void _onCategoryRefChanged(DocumentRef? categoryId) {
    if (categoryId == null || categoryId is! SignedDocumentRef) {
      return;
    }

    Router.neglect(context, () {
      CategoryDetailRoute.fromRef(categoryId: categoryId).replace(context);
    });
  }
}
