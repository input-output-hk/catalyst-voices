import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalVersionViewModel extends Equatable {
  final String title;
  final DocumentRef selfRef;
  final DateTime createdAt;
  final ProposalPublish publish;
  final bool isLatest;
  final bool isLatestLocal;
  final int versionNumber;

  const ProposalVersionViewModel({
    required this.title,
    required this.selfRef,
    required this.createdAt,
    required this.publish,
    required this.isLatest,
    required this.isLatestLocal,
    required this.versionNumber,
  });

  factory ProposalVersionViewModel.fromProposalVersion(
    ProposalVersion version, {
    required bool isLatest,
    required bool isLatestLocal,
    required int versionNumber,
  }) {
    return ProposalVersionViewModel(
      title: version.title,
      selfRef: version.selfRef,
      createdAt: version.createdAt,
      publish: version.publish,
      isLatest: isLatest,
      isLatestLocal: isLatestLocal,
      versionNumber: versionNumber,
    );
  }

  @override
  List<Object?> get props => [
    title,
    selfRef,
    createdAt,
    publish,
    isLatest,
    isLatestLocal,
    versionNumber,
  ];

  ProposalVersionViewModel copyWith({
    String? title,
    DocumentRef? selfRef,
    DateTime? createdAt,
    ProposalPublish? publish,
    bool? isLatest,
    bool? isLatestLocal,
    int? versionNumber,
  }) {
    return ProposalVersionViewModel(
      title: title ?? this.title,
      selfRef: selfRef ?? this.selfRef,
      createdAt: createdAt ?? this.createdAt,
      publish: publish ?? this.publish,
      isLatest: isLatest ?? this.isLatest,
      isLatestLocal: isLatestLocal ?? this.isLatestLocal,
      versionNumber: versionNumber ?? this.versionNumber,
    );
  }
}

extension ProposalVersionViewModelListExt on List<ProposalVersionViewModel> {
  ProposalVersionViewModel get latest => firstWhere((e) => e.isLatest);
}

extension ProposalVersionViewModelMapper on List<ProposalVersion> {
  List<ProposalVersionViewModel> toViewModels() {
    return map(
      (version) => ProposalVersionViewModel.fromProposalVersion(
        version,
        isLatest: first.selfRef == version.selfRef,
        isLatestLocal: first.selfRef == version.selfRef && version.publish.isLocal,
        versionNumber: versionNumber(version.selfRef.version!),
      ),
    ).toList();
  }
}
