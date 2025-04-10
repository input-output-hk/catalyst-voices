import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalDocumentData extends Equatable {
  final DocumentData proposal;
  final DocumentData template;

  const ProposalDocumentData({
    required this.proposal,
    required this.template,
  });

  @override
  List<Object?> get props => [
        proposal,
        template,
      ];
}
