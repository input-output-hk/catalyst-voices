import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

abstract class VoicesConstants {
  /// External urls
  static const supportedWalletsUrl =
      'https://docs.projectcatalyst.io/current-fund/voter-registration/supported-wallets';
  static const tosUrl =
      'https://docs.projectcatalyst.io/current-fund/fund-basics/project-catalyst-terms-and-conditions';
  static const privacyPolicyUrl =
      'https://docs.projectcatalyst.io/current-fund/fund-basics/project-catalyst-terms-and-conditions/catalyst-fc-privacy-policy';
  static const supportUrl = 'https://catalystiog.zendesk.com/hc/en-us/requests/new';
  static const docsUrl = 'https://docs.projectcatalyst.io/';
  static const beforeSubmissionUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/app-timeline#before-submission';
  static const afterSubmissionUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/stay-involved';
  static const becomeReviewerUrl = 'https://reviews.projectcatalyst.io/';
  static const votingRegistrationUrl =
      'https://docs.projectcatalyst.io/current-fund/voter-registration';
  static const walletTroubleshootingUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started#wallet-connect-troubleshooting';
  static const mobileExperienceUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/mobile-experience';
  static const catalystKnowledgeBaseUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app';
  static const proposalPublishingDocsUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/create-and-submit-proposals-in-workspace#proposal-publishing';
  static const getStartedUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started';
  static const setupBaseProfileUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started#setup-base-profile';
  static const createCatalystKeychainUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started#create-catalyst-keychain';
  static const officiallySupportedWalletsUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started#officially-supported-wallets';
  static const linkCardanoWalletUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started#link-cardano-wallet-and-roles';
  static const selectRolesUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started#select-roles';
  static const submitRegistrationTransactionUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/getting-started#submit-registration-transaction';
  static const restoreKeychainUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/restore-keychain';
  static const myAccountUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/my-account';
  static const insertNewImageDocsUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/create-and-submit-proposals-in-workspace/using-images';
  static const joinNewsletterUrl = 'https://mpc.projectcatalyst.io/newsletter-signup';
  static const unlockAccountUrl =
      'https://docs.projectcatalyst.io/catalyst-tools/catalyst-app/my-account#lock-unlock-account';

  static String cardanoScanStakeAddressUrl(ShelleyAddress stakeAddress) {
    switch (stakeAddress.network) {
      case NetworkId.mainnet:
        return 'https://cardanoscan.io/stakekey/${stakeAddress.toBech32()}';
      case NetworkId.testnet:
        return 'https://preprod.cardanoscan.io/stakekey/${stakeAddress.toBech32()}';
    }
  }
}
