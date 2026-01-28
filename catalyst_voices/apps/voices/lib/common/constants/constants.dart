import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

/// Exposes static refs to external services.
abstract class VoicesConstants {
  static const _docs = 'https://docs.projectcatalyst.io';
  static const _catalystApp = '$_docs/catalyst-tools/catalyst-app';
  static const _projectCatalyst = 'https://projectcatalyst.io';

  /// External urls
  static const supportedWalletsUrl = '$_docs/current-fund/voter-registration/supported-wallets';
  static const tosUrl =
      '$_docs/current-fund/fund-basics/project-catalyst-terms-and-conditions/project-catalyst-platform-terms-of-use';
  static const conditionsUrl =
      '$_docs/current-fund/fund-basics/project-catalyst-terms-and-conditions';
  static const privacyPolicyUrl =
      '$_docs/current-fund/fund-basics/project-catalyst-terms-and-conditions/project-catalyst-platform-privacy-policy';
  static const supportUrl = 'https://catalystiog.zendesk.com/hc/en-us/requests/new';
  static const docsUrl = '$_docs/';
  static const beforeSubmissionUrl = '$_catalystApp/app-timeline#before-submission';
  static const afterSubmissionUrl = '$_catalystApp/stay-involved';
  static const votingRegistrationUrl = '$_docs/current-fund/voter-registration';
  static const walletTroubleshootingUrl =
      '$_catalystApp/getting-started#wallet-connect-troubleshooting';
  static const mobileExperienceUrl = '$_catalystApp/mobile-experience';
  static const catalystKnowledgeBaseUrl = _catalystApp;
  static const proposalPublishingDocsUrl =
      '$_catalystApp/create-and-submit-proposals-in-workspace#proposal-publishing';
  static const getStartedUrl = '$_catalystApp/getting-started';
  static const setupBaseProfileUrl = '$_catalystApp/getting-started#setup-base-profile';
  static const createCatalystKeychainUrl = '$_catalystApp/getting-started#create-catalyst-keychain';
  static const officiallySupportedWalletsUrl =
      '$_catalystApp/getting-started#officially-supported-wallets';
  static const linkCardanoWalletUrl = '$_catalystApp/getting-started#link-cardano-wallet-and-roles';
  static const selectRolesUrl = '$_catalystApp/getting-started#select-roles';
  static const submitRegistrationTransactionUrl =
      '$_catalystApp/getting-started#submit-registration-transaction';
  static const restoreKeychainUrl = '$_catalystApp/restore-keychain';
  static const myAccountUrl = '$_catalystApp/my-account';
  static const insertNewImageDocsUrl =
      '$_catalystApp/create-and-submit-proposals-in-workspace/using-images';
  static const joinNewsletterUrl = 'https://mpc.projectcatalyst.io/newsletter-signup';
  static const unlockAccountUrl = '$_catalystApp/my-account#lock-unlock-account';
  static const confirmSeedPhraseUrl = '$_catalystApp/getting-started#confirm-seed-phrase';
  static const campaignTimeline = '$_docs/current-fund/fund-basics/fund-timeline';
  static const milestoneGuideline =
      '$_docs/current-fund/project-onboarding/milestone-based-proposals';

  const VoicesConstants._();

  static String cardanoScanStakeAddressUrl(ShelleyAddress stakeAddress) {
    switch (stakeAddress.network) {
      case NetworkId.mainnet:
        return 'https://cardanoscan.io/stakekey/${stakeAddress.toBech32()}';
      case NetworkId.testnet:
        return 'https://preprod.cardanoscan.io/stakekey/${stakeAddress.toBech32()}';
    }
  }

  static String fundProposalSubmissionNoticeUrl(int fundNumber) =>
      '$_docs/current-fund/fund-basics/fund$fundNumber-proposal-submission-notice';

  // TODO(dt-iohk): Add a correct link to the voting results page
  static String fundVotingResultsUrl(int fundNumber) => projectCatalystFundUrl(fundNumber);

  static String projectCatalystFundUrl(int fundNumber) => '$_projectCatalyst/funds/$fundNumber';
}
