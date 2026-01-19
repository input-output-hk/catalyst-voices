import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class DocumentViewerData extends Equatable {
  final DocumentViewerHeader header;
  final List<Segment> segments;

  const DocumentViewerData({
    this.header = const DocumentViewerHeader(),
    this.segments = const [],
  });

  @override
  List<Object?> get props => [header, segments];
}
