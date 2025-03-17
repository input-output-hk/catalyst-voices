import 'dart:async';

import 'package:catalyst_voices_blocs/src/proposal_builder/new_proposal/new_proposal_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewProposalCubit extends Cubit<NewProposalState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final DocumentMapper _documentMapper;

  NewProposalCubit(
    this._campaignService,
    this._proposalService,
    this._documentMapper,
  ) : super(
          const NewProposalState(
            title: ProposalTitle.pure(),
          ),
        ) {
    unawaited(getCampaignCategories());
  }

  Future<DraftRef> createDraft() async {
    final title = state.title;
    final categoryId = state.categoryId;

    if (categoryId == null) {
      throw StateError('Cannot create draft, title or category not selected');
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

    return _proposalService.createDraftProposal(
      content: documentContent,
      template: templateRef,
      categoryId: categoryId,
    );
  }

  Future<void> getCampaignCategories() async {
    final categories = await _campaignService.getCampaignCategories();
    final categoriesModel =
        categories.map(CampaignCategoryDetailsViewModel.fromModel).toList();
    emit(
      state.copyWith(
        categories: categoriesModel,
        categoryId: Optional(categoriesModel.first.id),
      ),
    );
  }

  void updateSelectedCategory(SignedDocumentRef? categoryId) {
    emit(state.copyWith(categoryId: Optional(categoryId)));
  }

  void updateTitle(ProposalTitle title) {
    emit(state.copyWith(title: title));
  }
}
