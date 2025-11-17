import 'package:equatable/equatable.dart';

final class ProposalTemplateTotalAsk extends Equatable {
  final int totalAsk;
  final int finalProposalsCount;

  const ProposalTemplateTotalAsk({
    required this.totalAsk,
    required this.finalProposalsCount,
  });

  @override
  List<Object?> get props => [
    totalAsk,
    finalProposalsCount,
  ];
}
