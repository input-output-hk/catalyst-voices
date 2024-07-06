const Chrome = require('selenium-webdriver/chrome');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
import { Builder, By, until, WebDriver, WebElement } from 'selenium-webdriver';

describe('Lace Wallet Integration Tests', () => {
  let driver, bridge;

  beforeAll(async () => {
      const options = new chrome.Options();
      if (process.env.CI) {
          options.addArguments('--headless');
      }
      driver = await new Builder()
          .forBrowser('chrome')
          .setChromeOptions(options)
          .setChromeOptions(options.addExtensions(['./lace/lace.crx']))
          .build();
      bridge = new FlutterSeleniumBridge(driver);
  });

  afterAll(async () => {
      await driver.quit();
  });

  beforeEach(async () => {
      const port = '3333';
      await driver.get(`http://127.0.0.1:${port}`);
  });

//   test('should make the App Main Screen be found with enableAccessibility', async () => {
//       await bridge.enableAccessibility(60000);

//       const labelXPath = '//flt-semantics[contains(@aria-label, "App Main Screen")]';
//       let label = await driver.wait(until.elementLocated(By.xpath(labelXPath)), 30000);

//       expect(label).toBeDefined();
//   });

  test('should make the "Click Me" button clickable with enableAccessibility and display "You clicked me" message', async () => {
      await bridge.enableAccessibility(60000);

      const clickMeButtonXPath = '//flt-semantics[contains(@aria-label, "Click Me")]';
      let clickMeButton = await driver.wait(until.elementLocated(By.xpath(clickMeButtonXPath)), 30000);

      clickMeButton.click();

      const clickedMeLabelXPath = '//flt-semantics[contains(@aria-label, "You clicked me")]';
      let clickedMeLabel = await driver.wait(until.elementLocated(By.xpath(clickedMeLabelXPath)), 30000);

      expect(clickedMeLabel).toBeDefined();
  });


//   test('should throw an error if no input element found', async () => {
//       await bridge.enableAccessibility(60000);

//       const nonInputXPath = '//flt-semantics[contains(@aria-label, "Click Me")]';

//       await expect(bridge.activateInputField(By.xpath(nonInputXPath), 5000))
//           .rejects
//           .toThrow('No input or textarea element found as a child of flt-semantics.');
//   });
});



// describe('Test Lace Extension', () => {
//   let driver;

//   beforeAll(async () => {
//      driver = await new Builder()
//     .forBrowser('chrome')
//     .setChromeOptions(options.addExtensions(['./lace/lace.crx']))
//     .build();

//     const bridge = new FlutterSeleniumBridge(driver);
//     await driver.get('http://localhost:3333');
//      await bridge.enableAccessibility();
//   });

//   it('should render a button in the web application', async () => {
//     const buttonXPath = '//flt-semantics[contains(@aria-label, "Enable wallet")]';
//     const clickMeButton = await driver.findElement(By.xpath(buttonXPath));
//     await clickMeButton.click();
//   });
// });
