import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

abstract interface class DocumentViewerCollaboratorsCache {
  List<Collaborator> get collaborators;

  DocumentViewerCache copyWithCollaborators(List<Collaborator> collaborators);
}
