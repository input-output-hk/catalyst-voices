import { expect } from "@playwright/test";
import { test } from "../wallet_automation/extensionUtils/fixtures/test-fixtures";
import { WalletListPanel } from "../pageobjects/onboarding/create_flow/step_15_wallet_list";
import { WalletConfig } from "../wallet_automation/extensionUtils/wallets/walletUtils";
import { walletConfigs } from "../wallet_automation/extensionUtils/walletData/walletConfigs";
import { OnboardingBasePage } from "../pageobjects/onboarding/onboarding_base_page";
import { WalletConnectedPanel } from "../pageobjects/onboarding/create_flow/step_16_wallet_connected";
import { RoleOverviewPanel } from "../pageobjects/onboarding/create_flow/step_18_role_overview";
import { SignTransactionPanel } from "../pageobjects/onboarding/create_flow/step_19_sign_transaction";
import { AccountSetupSuccessPanel } from "../pageobjects/onboarding/create_flow/step_20_account_setup_success";

const walletConfig: WalletConfig = walletConfigs[0];

test("has title", async ({ restoreWallet }) => {
  const browser = await restoreWallet(walletConfig);
  const page = browser.pages()[0];
  await page.goto("http://localhost:54978/discovery");
  await new WalletListPanel(page).goto();
  const [popupPage] = await Promise.all([
    browser.waitForEvent('page'), 
    new WalletListPanel(page).connectLaceWallet(),
  ]);
  
  await popupPage.waitForLoadState('domcontentloaded');
  await popupPage.locator('body').click();
  await popupPage.locator('//*[@data-testid="connect-authorize-button"]').click();
  await popupPage.locator('//*[@data-testid="connect-modal-accept-always"]').click();
  await new OnboardingBasePage(page).nextButtonClick();
  await new OnboardingBasePage(page).nextButtonClick();
  await new RoleOverviewPanel(page).reviewTransactionClick();
  await page.waitForTimeout(3000);

  const [popupPageSignTx] = await Promise.all([
    browser.waitForEvent('page'), 
    new SignTransactionPanel(page).signTransactionClick(),
  ]);
  await popupPageSignTx.waitForLoadState('domcontentloaded');
  await popupPageSignTx.locator('body').click();
  await popupPageSignTx.locator('//*[@data-testid="dapp-transaction-confirm"]').click();
  await popupPageSignTx.locator('//*[@data-testid="password-input"]').fill(walletConfig.password);
  await popupPageSignTx.locator('//*[@data-testid="sign-transaction-confirm"]').click();

  await popupPageSignTx.close();
  await new AccountSetupSuccessPanel(page).openDiscoveryButtonClick();
  
});
