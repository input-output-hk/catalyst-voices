import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalVersionViewModel extends Equatable {
  final String title;
  final DocumentRef id;
  final DateTime createdAt;
  final ProposalPublish publish;
  final bool isLatest;
  final bool isLatestLocal;
  final int versionNumber;

  const ProposalVersionViewModel({
    required this.title,
    required this.id,
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
      id: version.id,
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
    id,
    createdAt,
    publish,
    isLatest,
    isLatestLocal,
    versionNumber,
  ];

  ProposalVersionViewModel copyWith({
    String? title,
    DocumentRef? id,
    DateTime? createdAt,
    ProposalPublish? publish,
    bool? isLatest,
    bool? isLatestLocal,
    int? versionNumber,
  }) {
    return ProposalVersionViewModel(
      title: title ?? this.title,
      id: id ?? this.id,
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
        isLatest: first.id == version.id,
        isLatestLocal: first.id == version.id && version.publish.isLocal,
        versionNumber: versionNumber(version.id.ver!),
      ),
    ).toList();
  }
}
