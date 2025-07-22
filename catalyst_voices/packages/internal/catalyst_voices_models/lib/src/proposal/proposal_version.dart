import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class ProposalVersion extends Equatable implements Comparable<ProposalVersion> {
  final DocumentRef selfRef;
  final String title;
  final DateTime createdAt;
  final ProposalPublish publish;

  ProposalVersion({
    required this.selfRef,
    required this.title,
    required this.createdAt,
    required this.publish,
  }) : assert(selfRef.version != null, 'SelfRef version cannot be null');

  factory ProposalVersion.fromData(BaseProposalData data) {
    final createdAt = data.document.metadata.selfRef.version!.dateTime;
    return ProposalVersion(
      selfRef: data.document.metadata.selfRef,
      title: data.document.title ?? '',
      createdAt: createdAt,
      publish: data.publish,
    );
  }

  @override
  List<Object?> get props => [
        selfRef,
        title,
        createdAt,
        publish,
      ];

  @override
  int compareTo(ProposalVersion other) {
    final versionA = selfRef.version ?? '';
    final versionB = other.selfRef.version ?? '';
    return versionB.compareTo(versionA);
  }
}

extension ProposalVersionsList on List<ProposalVersion> {
  ProposalVersion get latest => first;

  int versionNumber(String version) {
    return length - indexWhere((element) => element.selfRef.version == version);
  }
}
