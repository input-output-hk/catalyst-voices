import 'package:catalyst_voices_services/generated/api/vit.models.swagger.dart';

/// For some reason VitSS openapi spec does not play nice with generating
/// sub classes for Proposal while extending more then 2 level.
///
/// As temporary solution we're overriding not generated classes because
/// we're remove VitSS integration later.

// SimpleProposal

class SimpleProposal$ProposalCategory extends Proposal$ProposalCategory {
  SimpleProposal$ProposalCategory({
    super.categoryId,
    super.categoryName,
    super.categoryDescription,
  });

  factory SimpleProposal$ProposalCategory.fromJson(Map<String, dynamic> json) {
    return Proposal$ProposalCategory.fromJson(json)._toSimple();
  }
}

class SimpleProposal$Proposer extends Proposal$Proposer {
  SimpleProposal$Proposer({
    super.proposerName,
    super.proposerEmail,
    super.proposerUrl,
  });

  factory SimpleProposal$Proposer.fromJson(Map<String, dynamic> json) {
    return Proposal$Proposer.fromJson(json)._toSimple();
  }
}

// CommunityChoiceProposal

class CommunityChoiceProposal$ProposalCategory
    extends Proposal$ProposalCategory {
  CommunityChoiceProposal$ProposalCategory({
    super.categoryId,
    super.categoryName,
    super.categoryDescription,
  });

  factory CommunityChoiceProposal$ProposalCategory.fromJson(
    Map<String, dynamic> json,
  ) {
    return Proposal$ProposalCategory.fromJson(json)._toCommunityChoice();
  }
}

class CommunityChoiceProposal$Proposer extends Proposal$Proposer {
  CommunityChoiceProposal$Proposer({
    super.proposerName,
    super.proposerEmail,
    super.proposerUrl,
  });

  factory CommunityChoiceProposal$Proposer.fromJson(Map<String, dynamic> json) {
    return Proposal$Proposer.fromJson(json)._toCommunityChoice();
  }
}

// Private extension

extension _Proposal$ProposalCategoryExt on Proposal$ProposalCategory {
  SimpleProposal$ProposalCategory _toSimple() {
    return SimpleProposal$ProposalCategory(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryDescription: categoryDescription,
    );
  }

  CommunityChoiceProposal$ProposalCategory _toCommunityChoice() {
    return CommunityChoiceProposal$ProposalCategory(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryDescription: categoryDescription,
    );
  }
}

extension _Proposal$ProposerExt on Proposal$Proposer {
  SimpleProposal$Proposer _toSimple() {
    return SimpleProposal$Proposer(
      proposerName: proposerName,
      proposerEmail: proposerEmail,
      proposerUrl: proposerUrl,
    );
  }

  CommunityChoiceProposal$Proposer _toCommunityChoice() {
    return CommunityChoiceProposal$Proposer(
      proposerName: proposerName,
      proposerEmail: proposerEmail,
      proposerUrl: proposerUrl,
    );
  }
}
