import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class AddCollaboratorCubit extends Cubit<AddCollaboratorState>
    with
        BlocErrorEmitterMixin,
        BlocSignalEmitterMixin<AddCollaboratorSignal, AddCollaboratorState> {
  final ProposalService _proposalService;

  AddCollaboratorCubit(
    this._proposalService, {
    required CatalystId authorCatalystId,
    required Collaborators collaborators,
  }) : super(
         AddCollaboratorState(
           authorCatalystId: authorCatalystId,
           collaborators: collaborators,
           collaboratorIdState: const CollaboratorIdState(
             collaboratorId: CollaboratorCatalystId.pure(),
           ),
         ),
       );

  void updateCollaboratorId(String value) {
    final result = CollaboratorCatalystId.dirty(
      value: value,
      collaborators: state.collaborators.collaborators,
      authorCatalystId: state.authorCatalystId,
    );
    final error = result.error;

    if (error != null && error is! InvalidCatalystIdFormatValidationException) {
      emitError(error);
    }
    final newCollaboratorIdState = state.collaboratorIdState.copyWith(collaboratorId: result);
    emit(state.copyWith(collaboratorIdState: newCollaboratorIdState));
  }

  Future<void> validateCollaboratorId() async {
    final id = state.collaboratorIdState.collaboratorId.value;
    final catalystId = CatalystId.tryParse(id);

    if (catalystId == null) return;
    final newCollaboratorIdState = state.collaboratorIdState;
    emit(state.copyWith(collaboratorIdState: newCollaboratorIdState.copyWith(isLoading: true)));
    final result = await _proposalService.validateForCollaborator(catalystId);

    await Future.delayed(const Duration(seconds: 1), () {});
    emit(state.copyWith(collaboratorIdState: newCollaboratorIdState.copyWith(isLoading: false)));

    if (result) {
      emitSignal(const ValidCollaboratorIdSignal());
    } else {
      emitError(const LocalizedCollaboratorIsNotAProposerException());
    }
  }
}
