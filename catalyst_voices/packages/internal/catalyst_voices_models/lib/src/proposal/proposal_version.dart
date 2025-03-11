import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalVersion extends Equatable
    implements Comparable<ProposalVersion> {
  final DocumentRef selfRef;
  final String title;
  final DateTime updateDate;
  final ProposalPublish publish;

  const ProposalVersion({
    required this.selfRef,
    required this.title,
    required this.updateDate,
    required this.publish,
  });

  @override
  List<Object?> get props => [
        selfRef,
        title,
        updateDate,
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
