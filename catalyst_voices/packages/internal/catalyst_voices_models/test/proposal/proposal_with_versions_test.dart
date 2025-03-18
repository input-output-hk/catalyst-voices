import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';
import 'package:test/test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(ProposalWithVersions, () {
    test('check if versions are sorted from latest to oldest', () async {
      final proposalId = const Uuid().v7();
      final versionId1 = const Uuid().v7();
      await Future.delayed(const Duration(milliseconds: 1), () {});
      final versionId2 = const Uuid().v7();
      await Future.delayed(const Duration(milliseconds: 1), () {});
      final versionId3 = const Uuid().v7();

      final proposalWithVersions = ProposalWithVersions(
        selfRef: DocumentRef.build(
          id: proposalId,
          isDraft: true,
          version: versionId2,
        ),
        categoryId: SignedDocumentRef.generateFirstRef(),
        title: 'Title ver 1',
        description: 'Description ver 1',
        updateDate: DateTime.now(),
        fundsRequested: const Coin(100),
        status: ProposalStatus.draft,
        publish: ProposalPublish.localDraft,
        versionCount: 3,
        duration: 6,
        author: 'Alex Wells',
        commentsCount: 0,
        category: 'Cardano Use Cases / MVP',
        versions: [
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: DraftRef(
              id: proposalId,
              version: versionId1,
            ),
            title: 'Title ver 1',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: DraftRef(
              id: proposalId,
              version: versionId2,
            ),
            title: 'Title ver 2',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: DraftRef(
              id: proposalId,
              version: versionId3,
            ),
            title: 'Title ver 3',
            createdAt: DateTime.now(),
          ),
        ],
      );

      expect(
        proposalWithVersions.versions[2].selfRef.version,
        equals(versionId1),
      );
      expect(
        proposalWithVersions.versions[1].selfRef.version,
        equals(versionId2),
        reason: 'Should be the second latest version',
      );
      expect(
        proposalWithVersions.versions[0].selfRef.version,
        equals(versionId3),
        reason: 'Should be the latest version',
      );
    });

    test('check if proposal without version is the oldest', () async {
      final proposalId = const Uuid().v7();
      final versionId1 = const Uuid().v7();
      await Future.delayed(const Duration(milliseconds: 1), () {});
      final versionId2 = const Uuid().v7();

      final proposalWithVersions = ProposalWithVersions(
        selfRef: DocumentRef.build(
          id: proposalId,
          isDraft: true,
          version: versionId1,
        ),
        categoryId: SignedDocumentRef.generateFirstRef(),
        title: 'Title ver 1',
        description: 'Description ver 1',
        updateDate: DateTime.now(),
        fundsRequested: const Coin(100),
        status: ProposalStatus.draft,
        publish: ProposalPublish.localDraft,
        versionCount: 3,
        duration: 6,
        author: 'Alex Wells',
        commentsCount: 0,
        category: 'Cardano Use Cases / MVP',
        versions: [
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: DraftRef(
              id: proposalId,
              version: versionId1,
            ),
            title: 'Title ver 1',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: DraftRef(
              id: proposalId,
              version: versionId2,
            ),
            title: 'Title ver 2',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: DraftRef(
              id: proposalId,
            ),
            title: 'Title ver 3',
            createdAt: DateTime.now(),
          ),
        ],
      );

      expect(
        proposalWithVersions.versions.last.selfRef.version,
        isNull,
      );

      expect(
        proposalWithVersions.versions.first.selfRef.version,
        equals(versionId2),
      );
    });
  });
}
