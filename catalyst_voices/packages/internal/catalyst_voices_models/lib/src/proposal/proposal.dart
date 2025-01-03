import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/proposal/proposal_section.dart';
import 'package:equatable/equatable.dart';

// Note. This enum may be deleted later. Its here for backwards compatibility.
enum ProposalStatus { ready, draft, inProgress, private, open, live, completed }

enum ProposalPublish { draft, published }

enum ProposalAccess { private, public }

final class Proposal extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime updateDate;
  final DateTime? fundedDate;
  final Coin fundsRequested;
  final ProposalStatus status;
  final ProposalPublish publish;
  final ProposalAccess access;
  final List<ProposalSection> sections;

  // This may be a reference to class
  final String category;

  // Those may be getters.
  final int commentsCount;

  const Proposal({
    required this.id,
    required this.title,
    required this.description,
    required this.updateDate,
    this.fundedDate,
    required this.fundsRequested,
    required this.status,
    required this.publish,
    required this.access,
    required this.sections,
    required this.category,
    required this.commentsCount,
  });

  int get totalSegments => sections.length;

  int get completedSegments {
    return sections.where((element) => element.isCompleted).length;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        updateDate,
        fundedDate,
        fundsRequested.value,
        publish,
        access,
        sections,
        category,
        commentsCount,
      ];
}
