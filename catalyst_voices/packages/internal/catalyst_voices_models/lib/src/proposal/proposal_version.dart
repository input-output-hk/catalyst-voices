import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class ProposalVersion extends Equatable implements Comparable<ProposalVersion> {
  final DocumentRef id;
  final String title;
  final DateTime createdAt;
  final ProposalPublish publish;

  ProposalVersion({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.publish,
  }) : assert(id.ver != null, 'id version cannot be null');

  factory ProposalVersion.fromData(ProposalData data) {
    final createdAt = data.document.metadata.id.ver!.dateTime;
    return ProposalVersion(
      id: data.document.metadata.id,
      title: data.document.title ?? '',
      createdAt: createdAt,
      publish: data.publish,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    createdAt,
    publish,
  ];

  @override
  int compareTo(ProposalVersion other) {
    final versionA = id.ver ?? '';
    final versionB = other.id.ver ?? '';
    return versionB.compareTo(versionA);
  }
}

extension ProposalVersionsList on List<ProposalVersion> {
  ProposalVersion get latest => first;

  int versionNumber(String version) {
    return length - indexWhere((element) => element.id.ver == version);
  }
}
