import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class Proposal extends ProposalBase {
  /// A hardcoded [NodeId] of the title property.
  /// 
  /// Since properties are dynamic the application cannot determine
  /// which property is the title in any other way than
  /// by hardcoding it's node ID.
  static final titleNodeId = DocumentNodeId.fromString('setup.title.title');

  final ProposalDocument document;

  const Proposal({
    required super.id,
    required super.title,
    required super.description,
    required super.updateDate,
    required super.fundsRequested,
    required super.status,
    required super.publish,
    required super.category,
    required super.commentsCount,
    required this.document,
    required super.version,
    required super.duration,
    required super.author,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        document,
      ];
}
