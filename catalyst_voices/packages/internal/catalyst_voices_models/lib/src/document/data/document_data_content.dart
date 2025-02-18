import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Raw document content class. At this level we can't really make sense of
/// what [data] is. [DocumentDataMetadata] is required and most likely
/// [Document] will be produced out of it.
final class DocumentDataContent extends Equatable {
  final Map<String, dynamic> data;

  const DocumentDataContent(this.data);

  // TODO(damian-molinski): should somehow query data
  String? get title => null;

  @override
  List<Object?> get props => [data];
}
