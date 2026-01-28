import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class DocumentViewerData<Header extends DocumentViewerHeader> extends Equatable {
  final Header header;
  final List<Segment> segments;

  const DocumentViewerData({
    required this.header,
    this.segments = const [],
  });

  @override
  List<Object?> get props => [header, segments];
}
