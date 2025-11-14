import 'dart:async';

import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/new_proposal/new_proposal_cache.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/new_proposal/new_proposal_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('NewProposalCubit');

/// Manages creation of new proposal.
class NewProposalCubit extends Cubit<NewProposalState>
    with BlocErrorEmitterMixin<NewProposalState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final DocumentMapper _documentMapper;

  NewProposalCache _cache = const NewProposalCache();

  StreamSubscription<Campaign?>? _activeCampaignSub;
  StreamSubscription<CampaignTotalAsk>? _activeCampaignTotalAskSub;

  NewProposalCubit(
    this._campaignService,
    this._proposalService,
    this._documentMapper,
  ) : super(
        const NewProposalState(
          title: ProposalTitle.pure(),
        ),
      );

  @override
  Future<void> close() async {
    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    await _activeCampaignTotalAskSub?.cancel();
    _activeCampaignTotalAskSub = null;

    return super.close();
  }

  Future<DraftRef?> createDraft() async {
    try {
      emit(state.copyWith(isCreatingProposal: true));

      final title = state.title.value;
      final categoryId = state.categoryRef;

      if (categoryId == null) {
        throw StateError('Cannot create draft, category not selected');
      }

      final category = await _campaignService.getCategory(categoryId);
      final templateRef = category.proposalTemplateRef;
      final template = await _proposalService.getProposalTemplate(
        ref: templateRef,
      );

      final documentBuilder = DocumentBuilder.fromSchema(schema: template.schema)
        ..addChange(
          DocumentValueChange(
            nodeId: ProposalDocument.titleNodeId,
            value: title,
          ),
        );

      final document = documentBuilder.build();
      final documentContent = _documentMapper.toContent(document);

      return await _proposalService.createDraftProposal(
        content: documentContent,
        template: templateRef,
        categoryId: categoryId,
      );
    } catch (error, stackTrace) {
      _logger.severe('Create draft', error, stackTrace);
      emitError(LocalizedException.create(error));
      return null;
    } finally {
      emit(state.copyWith(isCreatingProposal: false));
    }
  }

  Future<void> load({SignedDocumentRef? categoryRef}) async {
    _cache = _cache.copyWith(categoryRef: Optional(categoryRef));

    emit(NewProposalState.loading());

    if (_cache.activeCampaign == null) {
      await _getActiveCampaign();
    }

    if (_activeCampaignSub == null) {
      _watchActiveCampaign();
    }

    await _updateCampaignCategoriesState();
  }

  void selectCategoryStage() {
    const stage = CreateProposalWithoutPreselectedCategoryStep(
      stage: CreateProposalStage.selectCategory,
    );
    emit(state.copyWith(step: stage));
  }

  void updateAgreeToCategoryCriteria({required bool value}) {
    emit(state.copyWith(isAgreeToCategoryCriteria: value));
  }

  void updateAgreeToNoFurtherCategoryChange({required bool value}) {
    emit(state.copyWith(isAgreeToNoFurtherCategoryChange: value));
  }

  void updateSelectedCategory(SignedDocumentRef? categoryRef) {
    emit(
      state.copyWith(
        categoryRef: Optional(categoryRef),
        isAgreeToCategoryCriteria: false,
        isAgreeToNoFurtherCategoryChange: false,
      ),
    );
  }

  void updateTitle(String title) {
    emit(state.copyWith(title: ProposalTitle.dirty(title, state.titleLengthRange)));
  }

  void updateTitleStage() {
    const stage = CreateProposalWithoutPreselectedCategoryStep();
    emit(state.copyWith(step: stage));
  }

  Future<void> _getActiveCampaign() async {
    try {
      final campaign = await _campaignService.getActiveCampaign();

      _handleActiveCampaignChange(campaign);
    } catch (error, stackTrace) {
      _logger.severe('Load', error, stackTrace);

      // TODO(dt-iohk): handle error state as dialog content,
      // don't emit the error
      emitError(LocalizedException.create(error));
    }
  }

  void _handleActiveCampaignChange(Campaign? campaign) {
    if (_cache.activeCampaign?.selfRef == campaign?.selfRef) {
      return;
    }

    _cache = _cache.copyWith(
      activeCampaign: Optional(campaign),
      campaignTotalAsk: const Optional.empty(),
    );

    unawaited(_updateCampaignCategoriesState());

    unawaited(_activeCampaignTotalAskSub?.cancel());
    _activeCampaignTotalAskSub = null;

    if (campaign != null) _watchCampaignTotalAsk(campaign);
  }

  void _handleCampaignTotalAskChange(CampaignTotalAsk data) {
    _cache = _cache.copyWith(campaignTotalAsk: Optional(data));

    unawaited(_updateCampaignCategoriesState());
  }

  Future<void> _updateCampaignCategoriesState() async {
    final campaign = _cache.activeCampaign;
    final campaignTotalAsk = _cache.campaignTotalAsk ?? const CampaignTotalAsk(categoriesAsks: {});
    final preselectedCategory = _cache.categoryRef;

    // TODO(LynxLynxx): when we have separate proposal template for generic questions use it here
    // right now user can start creating proposal without selecting category.
    // Right now every category have the same requirements for title so we can do a fallback for
    // first category from the list.
    final categories = campaign?.categories ?? [];
    final templateRef = categories
        .cast<CampaignCategory?>()
        .firstWhere(
          (e) => e?.selfRef == preselectedCategory,
          orElse: () => categories.firstOrNull,
        )
        ?.proposalTemplateRef;

    final template = templateRef != null
        ? await _proposalService.getProposalTemplate(ref: templateRef)
        : null;
    final titleRange = template?.title?.strLengthRange;

    final stateCategories = categories.map(
      (category) {
        final categoryTotalAsk =
            campaignTotalAsk.categoriesAsks[category.selfRef] ??
            CampaignCategoryTotalAsk.zero(category.selfRef);

        return CampaignCategoryDetailsViewModel.fromModel(
          category,
          finalProposalsCount: categoryTotalAsk.finalProposalsCount,
          totalAsk: categoryTotalAsk.totalAsk,
        );
      },
    ).toList();

    final step = _cache.categoryRef == null
        ? const CreateProposalWithoutPreselectedCategoryStep()
        : const CreateProposalWithPreselectedCategoryStep();

    final newState = state.copyWith(
      isLoading: false,
      step: step,
      categoryRef: Optional(_cache.categoryRef),
      titleLengthRange: Optional(titleRange),
      categories: stateCategories,
    );

    if (!isClosed) {
      emit(newState);
    }
  }

  void _watchActiveCampaign() {
    unawaited(_activeCampaignSub?.cancel());
    _activeCampaignSub = _campaignService.watchActiveCampaign
        .distinct((previous, next) => previous?.selfRef != next?.selfRef)
        .listen(_handleActiveCampaignChange);
  }

  void _watchCampaignTotalAsk(Campaign campaign) {
    _activeCampaignTotalAskSub = _campaignService
        .watchCampaignTotalAsk(filters: CampaignFilters.from(campaign))
        .distinct()
        .listen(_handleCampaignTotalAskChange);
  }
}
