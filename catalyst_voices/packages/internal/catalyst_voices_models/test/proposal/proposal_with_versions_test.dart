import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(DetailProposal, () {
    test('check if versions are sorted from latest to oldest', () async {
      final proposalId = DocumentRefFactory.randomUuidV7();
      final versionId1 = DocumentRefFactory.randomUuidV7();
      final versionId2 = DocumentRefFactory.randomUuidV7();
      final versionId3 = DocumentRefFactory.randomUuidV7();

      final proposalWithVersions = DetailProposal(
        id: DocumentRef.build(
          id: proposalId,
          isDraft: true,
          ver: versionId2,
        ),
        parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
        title: 'Title ver 1',
        description: 'Description ver 1',
        fundsRequested: Money(currency: Currencies.ada, minorUnits: BigInt.from(100)),
        publish: ProposalPublish.localDraft,
        duration: 6,
        author: 'Alex Wells',
        commentsCount: 0,
        versions: [
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: DraftRef(
              id: proposalId,
              ver: versionId1,
            ),
            title: 'Title ver 1',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: DraftRef(
              id: proposalId,
              ver: versionId2,
            ),
            title: 'Title ver 2',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: DraftRef(
              id: proposalId,
              ver: versionId3,
            ),
            title: 'Title ver 3',
            createdAt: DateTime.now(),
          ),
        ],
      );

      expect(
        proposalWithVersions.versions[2].id.ver,
        equals(versionId1),
      );
      expect(
        proposalWithVersions.versions[1].id.ver,
        equals(versionId2),
        reason: 'Should be the second latest version',
      );
      expect(
        proposalWithVersions.versions[0].id.ver,
        equals(versionId3),
        reason: 'Should be the latest version',
      );
    });

    test('check if proposal without version is the oldest', () async {
      final proposalId = DocumentRefFactory.randomUuidV7();
      final versionId1 = DocumentRefFactory.randomUuidV7();
      final versionId2 = DocumentRefFactory.randomUuidV7();

      final proposalWithVersions = DetailProposal(
        id: DocumentRef.build(
          id: proposalId,
          isDraft: true,
          ver: versionId1,
        ),
        parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
        title: 'Title ver 1',
        description: 'Description ver 1',
        fundsRequested: Money(currency: Currencies.ada, minorUnits: BigInt.from(100)),
        publish: ProposalPublish.localDraft,
        duration: 6,
        author: 'Alex Wells',
        commentsCount: 0,
        versions: [
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: DraftRef(
              id: proposalId,
              ver: versionId1,
            ),
            title: 'Title ver 1',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: DraftRef(
              id: proposalId,
              ver: versionId2,
            ),
            title: 'Title ver 2',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: DraftRef(
              id: proposalId,
              ver: proposalId,
            ),
            title: 'Title ver 3',
            createdAt: DateTime.now(),
          ),
        ],
      );

      expect(
        proposalWithVersions.versions.first.id.ver,
        equals(versionId2),
      );
    });
  });
}
