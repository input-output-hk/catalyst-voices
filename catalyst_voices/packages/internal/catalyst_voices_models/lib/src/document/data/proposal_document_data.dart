import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalDocumentData extends Equatable {
  final DocumentData proposal;
  final DocumentData template;
  final DocumentData? action;
  final int commentsCount;
  final List<String> versions;

  const ProposalDocumentData({
    required this.proposal,
    required this.template,
    this.action,
    this.commentsCount = 0,
    this.versions = const [],
  });

  @override
  List<Object?> get props => [
        proposal,
        template,
        action,
        commentsCount,
        versions,
      ];
}
