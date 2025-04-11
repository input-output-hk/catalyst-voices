import 'package:catalyst_voices/widgets/common/simple_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../proposal_menu_branch_classes/proposals_sidebar_branch_classes.dart';
class ProposalsPageSidebarPanel {
  ProposalsPageSidebarPanel(this.$);
  late PatrolTester $;
  late final overview = Overview($);
  
  final proposalSetupBranch = const ValueKey('Segment[1]NodeMenu');
  final proposalSummaryBranch = const ValueKey('Segment[2]NodeMenu');
  final campaignCategoryBranch = const ValueKey('Segment[3]NodeMenu');
  final themeSelectionBranch = const ValueKey('Segment[4]NodeMenu');
  final yourProjectAndSolutionBranch = const ValueKey('Segment[5]NodeMenu');
  final milestonesBranch = const ValueKey('Segment[6]NodeMenu');
  final finalPitchBranch = const ValueKey('Segment[7]NodeMenu');
  final acknowledgementsBranch = const ValueKey('Segment[8]NodeMenu');
  final commentsBranch = const ValueKey('Segment[9]NodeMenu');
  final metadata=const ValueKey('NodeMenuoverview.metadataRowKey');
  final proposalTitle = const ValueKey('NodeMenusetup.titleRowKey');
  final proposer=const ValueKey('NodeMenusetup.proposerRowKey');
  
  

  Future<void> clickProposalSetupBranch() async {
    await $(proposalSetupBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickProposalSummaryBranch() async {
    await $(proposalSummaryBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickCampaignCategoryBranch() async {
    await $(campaignCategoryBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickThemeSelectionBranch() async {
    await $(themeSelectionBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickYourProjectAndSolutionBranch() async {
    await $(yourProjectAndSolutionBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickMilestonesBranch() async {
    await $(milestonesBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickFinalPitchBranch() async {
    await $(finalPitchBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickAcknowledgementsBranch() async {
    await $(acknowledgementsBranch).$(SimpleTreeViewRootRow).tap();
  }

  Future<void> clickCommentsBranch() async {
    await $(commentsBranch).$(SimpleTreeViewRootRow).tap();
  }



}
