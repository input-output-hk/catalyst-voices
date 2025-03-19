import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class ProposalVersion extends Equatable
    implements Comparable<ProposalVersion> {
  final DocumentRef selfRef;
  final String title;
  final DateTime createdAt;
  final ProposalPublish publish;

  const ProposalVersion({
    required this.selfRef,
    required this.title,
    required this.createdAt,
    required this.publish,
  });

  factory ProposalVersion.fromData(BaseProposalData data) {
    final createdAt = data.document.metadata.selfRef.version!.dateTime;
    return ProposalVersion(
      selfRef: data.document.metadata.selfRef,
      title: BaseProposalData.getProposalTitle(data.document) ?? '',
      createdAt: createdAt,
      // TODO(LynxLynxx): change when we get this from doc actions
      publish: ProposalPublish.publishedDraft,
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

  /// Checks if this versions is the latest version
  /// compared to the given [version].
  bool isLatestVersion(String version) {
    final thisVersion = selfRef.version ?? '';
    return thisVersion.compareTo(version) > 0;
  }
}

extension ProposalVersionsList on List<ProposalVersion> {
  int versionNumber(String version) {
    return length - indexWhere((element) => element.selfRef.version == version);
  }
}
