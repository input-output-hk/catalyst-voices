import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('DocumentViewerCollaboratorsMixin');

/// Mixin providing collaborators functionality for document viewers.
base mixin DocumentViewerCollaboratorsMixin<
  State extends DocumentViewerState,
  Cache extends DocumentViewerCache<Cache>
>
    on DocumentViewerCubit<State, Cache>
    implements DocumentViewerCollaborators {
  @override
  Future<void> acceptCollaboratorInvitation() async {
    try {
      final id = cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot accept collaborator invitation for a draft proposal: $id');
      }

      await proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.acceptInvitation,
      );
      cache = cache.copyWith(
        collaboratorsState: const AcceptedCollaboratorInvitationState(),
      );

      if (!isClosed) {
        rebuildState();
      }
    } catch (error, stackTrace) {
      _logger.severe('acceptCollaboratorInvitation', error, stackTrace);

      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> acceptFinalProposal() async {
    try {
      final id = cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot accept collaborator invitation for a draft proposal: $id');
      }

      await proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.acceptFinal,
      );
      cache = cache.copyWith(collaboratorsState: const AcceptedFinalProposalConsentState());

      if (!isClosed) {
        rebuildState();
      }
    } catch (error, stackTrace) {
      _logger.severe('acceptFinalProposal', error, stackTrace);

      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @protected
  void buildCollaboratorState({
    required List<ProposalDataCollaborator> collaborators,
    required CatalystId? activeAccountId,
    required bool isFinal,
  }) {
    final collaboratorState = CollaboratorProposalState.fromCollaboratorData(
      collaborators: collaborators,
      activeAccountId: activeAccountId,
      isFinal: isFinal,
    );
    cache = cache.copyWith(collaboratorsState: collaboratorState);
  }

  @override
  void dismissCollaboratorBanner() {
    cache = cache.copyWith(collaboratorsState: const NoneCollaboratorProposalState());

    rebuildState();
  }

  @override
  Future<void> rejectCollaboratorInvitation() async {
    try {
      final id = cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot accept collaborator invitation for a draft proposal: $id');
      }

      await proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.rejectInvitation,
      );

      cache = cache.copyWith(
        collaboratorsState: const RejectedCollaboratorInvitationState(),
      );

      if (!isClosed) {
        rebuildState();
      }
    } catch (error, stackTrace) {
      _logger.severe('rejectCollaboratorInvitation', error, stackTrace);

      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> rejectFinalProposal() async {
    try {
      final id = cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot accept collaborator invitation for a draft proposal: $id');
      }

      await proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.rejectFinal,
      );

      cache = cache.copyWith(
        collaboratorsState: const RejectedCollaboratorFinalProposalConsentState(),
      );

      if (!isClosed) {
        rebuildState();
      }
    } catch (error, stackTrace) {
      _logger.severe('rejectFinalProposal', error, stackTrace);

      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }
}
