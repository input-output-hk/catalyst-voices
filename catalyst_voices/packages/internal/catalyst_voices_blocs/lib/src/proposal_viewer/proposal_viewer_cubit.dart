import 'package:catalyst_voices_blocs/src/document_viewer/document_viewer_cubit.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/mixins/document_viewer_collaborator_mixin.dart';
import 'package:catalyst_voices_blocs/src/proposal_viewer/proposal_viewer_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class ProposalViewerCubit extends DocumentViewerCubit<ProposalViewerState>
    with DocumentViewerCollaboratorsMixin {
  ProposalViewerCubit(
    super.initialState,
    super.proposalService,
    super.userService,
    super.documentMapper,
    super.featureFlagsService,
  );

  @override
  Future<void> acceptCollaboratorInvitation() async {
    try {
      await super.acceptCollaboratorInvitation();
      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedCollaboratorInvitationState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> acceptFinalProposal() async {
    try {
      await super.acceptFinalProposal();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedFinalProposalConsentState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  void dismissCollaboratorBanner() {
    emit(state.copyWith(collaborator: const NoneCollaboratorProposalState()));
  }

  Future<void> loadProposal(DocumentRef id) async {
    return super.loadDocument(id);
  }

  @override
  Future<void> rejectCollaboratorInvitation() async {
    try {
      await super.rejectCollaboratorInvitation();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorInvitationState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> rejectFinalProposal() async {
    try {
      await super.rejectFinalProposal();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorFinalProposalConsentState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<DocumentRef> resolveToLatestVersion(DocumentRef id) async {
    return proposalService.getLatestProposalVersion(id: id);
  }

  @override
  Future<void> retryLastRef() async {
    final id = cache.id;

    if (id != null) {
      return loadProposal(id);
    }
  }

  @override
  Future<void> syncAndWatchDocument() {
    // TODO: implement syncAndWatchDocument
    throw UnimplementedError();
  }

  @override
  Future<void> updateIsFavorite({required bool value}) {
    // TODO: implement updateIsFavorite
    throw UnimplementedError();
  }
}
