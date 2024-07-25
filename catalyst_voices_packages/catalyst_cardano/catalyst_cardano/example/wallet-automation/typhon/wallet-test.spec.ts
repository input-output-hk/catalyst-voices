import { test, expect } from '@playwright/test';
import { setupBrowserContext } from './wallet-extension';

test('Wallet Extension Test', async () => {
    const setup = await setupBrowserContext();
    const { browserContext, newPage } = setup;
    
    const emptyWalletSelector = '.web-electable-region-context-menu';
    const expectedText = 'There are no active wallet extensions';

    try {
        const emptyWalletElement = await newPage.waitForSelector(emptyWalletSelector, { timeout: 5000 });

        if (emptyWalletElement) {
            const emptyWalletText = await emptyWalletElement.textContent();
            expect(emptyWalletText).not.toBeNull();
            if (emptyWalletText) {
                expect(emptyWalletText).toContain(expectedText);
            } else {
                console.log('Element found but has no text content.');
            }
            console.log('Wallet extension was installed');
        }

        // const enableWalletXPath = '//div[class()="web-electable-region-context-menu"] and contains(text(), "Enable wallet")]';
        const enableWalletXPath = '//div[contains(@class, "web-electable-region-context-menu") and contains(text(), "Enable wallet")]';
        const enableWalletLocator = newPage.locator(enableWalletXPath);
        if (await enableWalletLocator.isVisible()) {
            await enableWalletLocator.click();
            console.log('Enable wallet');
        } else {
            console.log('Failure enable wallet');
        }

    } catch (error) {
        console.error('An error occurred when get the element:', error.message);
        throw new Error('An error occurred when get the element.');
    } finally {
        await browserContext.close();

    }


});
