import 'dart:async';

import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/proposal_submission_phase_aware.dart';
import 'package:catalyst_voices/pages/category/card_information.dart';
import 'package:catalyst_voices/pages/category/category_detail_view.dart';
import 'package:catalyst_voices/pages/category/draggable_sheet_category_information.dart';
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
  final SignedDocumentRef categoryRef;

  const CategoryPage({super.key, required this.categoryRef});

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

class _CategoryDetailErrorSelector extends StatelessWidget {
  final SignedDocumentRef categoryRef;

  const _CategoryDetailErrorSelector({required this.categoryRef});

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
                          context.read<CategoryDetailCubit>().getCategoryDetail(categoryRef),
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
    return BlocSelector<
      CategoryDetailCubit,
      CategoryDetailState,
      DataVisibilityState<CampaignCategoryDetailsViewModel>
    >(
      selector: (state) {
        return (
          show: state.isLoading,
          data: state.category ?? CampaignCategoryDetailsViewModel.dummy(),
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

class _CategoryPageState extends State<CategoryPage> {
  StreamSubscription<DocumentRef?>? _categoryRefSub;

  @override
  Widget build(BuildContext context) {
    return ProposalSubmissionPhaseAware(
      activeChild: Stack(
        children: [
          const _CategoryDetailLoadingOrDataSelector(),
          _CategoryDetailErrorSelector(
            categoryRef: widget.categoryRef,
          ),
        ].constrainedDelegate(),
      ),
    );
  }

  @override
  void didUpdateWidget(CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.categoryRef != oldWidget.categoryRef) {
      unawaited(
        context.read<CategoryDetailCubit>().getCategoryDetail(widget.categoryRef),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_categoryRefSub?.cancel());
    _categoryRefSub = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    unawaited(context.read<CategoryDetailCubit>().getCategories());
    unawaited(
      context.read<CategoryDetailCubit>().getCategoryDetail(widget.categoryRef),
    );
    _listenForProposalRef(context.read<CategoryDetailCubit>());
  }

  void _listenForProposalRef(CategoryDetailCubit cubit) {
    // listen for updates
    _categoryRefSub = cubit.stream
        .map((event) => event.category?.ref)
        .distinct()
        .listen(_onCategoryRefChanged);
  }

  void _onCategoryRefChanged(DocumentRef? categoryRef) {
    if (categoryRef == null || categoryRef is! SignedDocumentRef) {
      return;
    }

    Router.neglect(context, () {
      CategoryDetailRoute.fromRef(categoryRef: categoryRef).replace(context);
    });
  }
}
