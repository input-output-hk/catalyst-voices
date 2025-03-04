import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
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

  Proposal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? updateDate,
    Coin? fundsRequested,
    ProposalStatus? status,
    ProposalPublish? publish,
    int? commentsCount,
    int? duration,
    String? author,
    int? version,
    String? category,
  }) =>
      Proposal(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        updateDate: updateDate ?? this.updateDate,
        fundsRequested: fundsRequested ?? this.fundsRequested,
        status: status ?? this.status,
        publish: publish ?? this.publish,
        commentsCount: commentsCount ?? this.commentsCount,
        duration: duration ?? this.duration,
        author: author ?? this.author,
        version: version ?? this.version,
        document: document,
        category: category ?? this.category,
      );
}
