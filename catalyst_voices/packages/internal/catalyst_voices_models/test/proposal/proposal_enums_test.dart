import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(ProposalPublish, () {
    test('sort from latest status to earliest', () {
      final actual = [
        ProposalPublish.submittedProposal,
        ProposalPublish.localDraft,
        ProposalPublish.publishedDraft,
      ]..sort();

      expect(
        actual,
        equals([
          ProposalPublish.submittedProposal,
          ProposalPublish.publishedDraft,
          ProposalPublish.localDraft,
        ]),
      );
    });

    test('sort from earliest status to latest', () {
      final actual = [
        ProposalPublish.localDraft,
        ProposalPublish.publishedDraft,
        ProposalPublish.submittedProposal,
      ]..sort();

      expect(
        actual,
        equals([
          ProposalPublish.submittedProposal,
          ProposalPublish.publishedDraft,
          ProposalPublish.localDraft,
        ]),
      );
    });
  });
}
