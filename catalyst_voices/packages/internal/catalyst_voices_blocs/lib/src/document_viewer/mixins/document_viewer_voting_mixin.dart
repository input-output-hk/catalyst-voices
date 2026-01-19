import 'package:catalyst_voices_blocs/src/document_viewer/document_viewer_cubit.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

base mixin DocumentViewerVotingMixin on DocumentViewerCubit {
  VotingService get votingService;
}
