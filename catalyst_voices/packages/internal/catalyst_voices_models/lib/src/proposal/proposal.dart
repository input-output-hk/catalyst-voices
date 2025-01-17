import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class Proposal extends ProposalBase {
  final ProposalDocument document;

  const Proposal({
    required super.id,
    required super.title,
    required super.description,
    required super.updateDate,
    required super.fundsRequested,
    required super.status,
    required super.publish,
    required super.access,
    required super.category,
    required super.commentsCount,
    required this.document,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        document,
      ];
}
