import { HomePage } from '../pages/homePage';
import { test } from '../test-fixtures';
import { walletConfigs } from '../utils/walletConfigs';
import { allowExtension } from '../utils/wallets/walletUtils';

walletConfigs.forEach(( walletConfig ) => {
    test.describe(`Testing with ${walletConfig.extension.Name}`, () => {
        test.skip(walletConfig.extension.Name === 'Typhon', 'https://github.com/input-output-hk/catalyst-voices/issues/753');
        test('Get wallet details for ' + walletConfig.extension.Name, async ({ page, enableWallet }) => {
            await enableWallet(walletConfig);
            const walletCipData = await new HomePage(page).getWalletCipData();
            console.log(walletCipData.balance)
        });
    });
});