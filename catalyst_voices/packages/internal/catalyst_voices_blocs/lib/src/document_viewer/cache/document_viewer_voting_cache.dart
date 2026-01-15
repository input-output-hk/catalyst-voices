import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class DocumentViewerVotingCache {
  Vote? get vote;

  DocumentViewerCache copyWithVoting(Vote? vote);
}
