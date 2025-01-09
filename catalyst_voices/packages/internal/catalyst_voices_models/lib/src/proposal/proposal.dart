import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

// Note. This enum may be deleted later. Its here for backwards compatibility.
enum ProposalStatus { ready, draft, inProgress, private, open, live, completed }

enum ProposalPublish { draft, published }

enum ProposalAccess { private, public }

// Note. Most, if not all, fields will be removed from here because they come
// from document.
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

  // This may be a reference to class
  final String category;

  // Those may be getters.
  final int commentsCount;

  final Document document;

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
    required this.category,
    required this.commentsCount,
    required this.document,
  });

  int get totalSegments => 0;

  int get completedSegments => 0;

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
        category,
        commentsCount,
      ];
}
