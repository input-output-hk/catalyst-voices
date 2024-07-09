import { Builder, Browser, By, until, WebDriver, WebElement } from 'selenium-webdriver';
import { Options as ChromeOptions } from 'selenium-webdriver/chrome';

const LACE_EXTENSION_PATH = './extensions/lace.crx';

describe('Lace Wallet Integration Tests', () => {
  let driver: WebDriver;

  beforeAll(async () => {
    let chromeOptions = new ChromeOptions;
    chromeOptions.addExtensions(LACE_EXTENSION_PATH);

    if (process.env.CI) {
      chromeOptions.addArguments('--headless');
    }

    driver = await new Builder()
      .forBrowser(Browser.CHROME)
      .setChromeOptions(chromeOptions)
      .build();
  });

  afterAll(async () => {
    await driver.quit();
  });

  beforeEach(async () => {
    const port = '3333';
    await driver.get(`http://127.0.0.1:${port}`);
  });


  test('should click on "Enable wallet" button and open Lace extension', async () => {
    const clickMeButtonXPath = '//flt-semantics[(@id="flt-semantic-node-9")]';
    let clickMeButton = await driver.wait(until.elementLocated(By.xpath(clickMeButtonXPath)), 10000);

    await new Promise(resolve => setTimeout(resolve, 5000));

    clickMeButton.click();

    const originalWindow = await driver.getWindowHandle();

    await driver.wait(async () => {
      const handles = await driver.getAllWindowHandles();
      return handles.length > 1;
    }, 10000);

    let windowHandles = await driver.getAllWindowHandles();

    for (const handle of windowHandles) {
      if (handle !== originalWindow) {
        await driver.switchTo().window(handle);
        break;
      }
    }

    const createOrRestoreWalletButton = await driver.findElement(By.css('button[data-testid="create-or-restore-wallet-btn"]'));
    await new Promise(resolve => setTimeout(resolve, 2000));
    await createOrRestoreWalletButton.click();

    await new Promise(resolve => setTimeout(resolve, 5000));

    await driver.switchTo().window(originalWindow);

    await new Promise(resolve => setTimeout(resolve, 5000));
  });
});
