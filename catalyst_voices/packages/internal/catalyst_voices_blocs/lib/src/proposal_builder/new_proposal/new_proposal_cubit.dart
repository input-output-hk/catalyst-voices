import 'dart:async';

import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/new_proposal/new_proposal_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('NewProposalCubit');

class NewProposalCubit extends Cubit<NewProposalState>
    with BlocErrorEmitterMixin<NewProposalState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final UserObserver _userObserver;
  final DocumentMapper _documentMapper;

  NewProposalCubit(
    this._campaignService,
    this._proposalService,
    this._userObserver,
    this._documentMapper,
  ) : super(
          const NewProposalState(
            title: ProposalTitle.pure(),
          ),
        );

  Future<DraftRef?> createDraft() async {
    try {
      emit(state.copyWith(isCreatingProposal: true));

      final title = state.title.value;
      final categoryId = state.categoryId;

      if (categoryId == null) {
        throw StateError('Cannot create draft, category not selected');
      }

      final category = await _campaignService.getCategory(categoryId);
      final templateRef = category.proposalTemplateRef;
      final template = await _proposalService.getProposalTemplate(
        ref: templateRef,
      );

      final documentBuilder =
          DocumentBuilder.fromSchema(schema: template.schema)
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

  Future<void> load() async {
    try {
      emit(NewProposalState.loading());

      final account = _userObserver.user.activeAccount;
      if (account == null) {
        throw StateError('Account is missing');
      }
      final categories = await _getCategories();

      final newState = state.copyWith(
        isLoading: false,
        isMissingProposerRole: !account.hasRole(AccountRole.proposer),
        categories: categories,
        categoryId: Optional(categories.first.id),
      );

      emit(newState);
    } catch (error, stackTrace) {
      _logger.severe('Load', error, stackTrace);

      // TODO(dtscalac): handle error state as dialog content,
      // don't emit the error
      emitError(LocalizedException.create(error));
    }
  }

  void updateSelectedCategory(SignedDocumentRef? categoryId) {
    emit(state.copyWith(categoryId: Optional(categoryId)));
  }

  void updateTitle(ProposalTitle title) {
    emit(state.copyWith(title: title));
  }

  Future<List<CampaignCategoryDetailsViewModel>> _getCategories() async {
    final categories = await _campaignService.getCampaignCategories();
    return categories.map(CampaignCategoryDetailsViewModel.fromModel).toList();
  }
}
