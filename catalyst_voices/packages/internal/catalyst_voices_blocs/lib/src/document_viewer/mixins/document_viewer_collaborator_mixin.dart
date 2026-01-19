import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('DocumentViewerCollaboratorsMixin');

base mixin DocumentViewerCollaboratorsMixin<S extends DocumentViewerState>
    on DocumentViewerCubit<S> {
  ProposalService get _proposalService;

  @mustCallSuper
  @protected
  Future<void> acceptCollaboratorInvitation() async {
    try {
      await _proposalService.submitCollaboratorProposalAction(
        ref: cache.id!,
        action: CollaboratorProposalAction.acceptInvitation,
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
      await _proposalService.submitCollaboratorProposalAction(
        ref: cache.id!,
        action: CollaboratorProposalAction.acceptFinal,
      );
    } catch (error, stackTrace) {
      _logger.severe('acceptFinalProposal', error, stackTrace);
      rethrow;
    }
  }

  void dismissCollaboratorBanner();

  @mustCallSuper
  @protected
  Future<void> rejectCollaboratorInvitation() async {
    try {
      await _proposalService.submitCollaboratorProposalAction(
        ref: cache.id!,
        action: CollaboratorProposalAction.rejectInvitation,
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
      await _proposalService.submitCollaboratorProposalAction(
        ref: cache.id!,
        action: CollaboratorProposalAction.rejectFinal,
      );
    } catch (error, stackTrace) {
      _logger.severe('rejectFinalProposal', error, stackTrace);
      rethrow;
    }
  }
}
