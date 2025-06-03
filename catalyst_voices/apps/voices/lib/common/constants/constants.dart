import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract class VoicesConstants {
  static const _docs = 'https://docs.projectcatalyst.io';
  static const _catalystApp = '$_docs/catalyst-tools/catalyst-app';

  /// External urls
  static const supportedWalletsUrl = '$_docs/current-fund/voter-registration/supported-wallets';
  static const tosUrl = '$_docs/current-fund/fund-basics/project-catalyst-terms-and-conditions';
  static const privacyPolicyUrl =
      '$_docs/current-fund/fund-basics/project-catalyst-terms-and-conditions/catalyst-fc-privacy-policy';
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

  static String becomeReviewerUrl() {
    return Dependencies.instance.get<AppEnvironment>().type.reviews.toString();
  }

  static String cardanoScanStakeAddressUrl(ShelleyAddress stakeAddress) {
    switch (stakeAddress.network) {
      case NetworkId.mainnet:
        return 'https://cardanoscan.io/stakekey/${stakeAddress.toBech32()}';
      case NetworkId.testnet:
        return 'https://preprod.cardanoscan.io/stakekey/${stakeAddress.toBech32()}';
    }
  }
}
