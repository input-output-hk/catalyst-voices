import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_collaborators_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('DocumentViewerCollaboratorsMixin');

base mixin DocumentViewerCollaboratorsMixin<S extends DocumentViewerState>
    on DocumentViewerCubit<S> {
  @override
  ProposalService get proposalService;

  DocumentViewerCollaboratorsCache get _collaboratorsCache {
    assert(
      cache is DocumentViewerCollaboratorsCache,
      'Cache must implement DocumentViewerCollaboratorsCache',
    );
    return cache as DocumentViewerCollaboratorsCache;
  }

  @mustCallSuper
  @protected
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
      cache = _collaboratorsCache.copyWithCollaborators(
        const AcceptedCollaboratorInvitationState(),
      );
    } catch (error, stackTrace) {
      _logger.severe('acceptCollaboratorInvitation', error, stackTrace);
      rethrow;
    }
  }

  @mustCallSuper
  @protected
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
      cache = _collaboratorsCache.copyWithCollaborators(const AcceptedFinalProposalConsentState());
    } catch (error, stackTrace) {
      _logger.severe('acceptFinalProposal', error, stackTrace);
      rethrow;
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
    cache = _collaboratorsCache.copyWithCollaborators(collaboratorState);
  }

  @mustCallSuper
  @protected
  void dismissCollaboratorBanner() {
    cache = _collaboratorsCache.copyWithCollaborators(const NoneCollaboratorProposalState());
  }

  @mustCallSuper
  @protected
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

      cache = _collaboratorsCache.copyWithCollaborators(
        const RejectedCollaboratorInvitationState(),
      );
    } catch (error, stackTrace) {
      _logger.severe('rejectCollaboratorInvitation', error, stackTrace);
      rethrow;
    }
  }

  @mustCallSuper
  @protected
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

      cache = _collaboratorsCache.copyWithCollaborators(
        const RejectedCollaboratorFinalProposalConsentState(),
      );
    } catch (error, stackTrace) {
      _logger.severe('rejectFinalProposal', error, stackTrace);
      rethrow;
    }
  }
}
