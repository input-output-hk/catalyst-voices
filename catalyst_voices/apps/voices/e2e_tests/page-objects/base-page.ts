import { Locator, Page } from "@playwright/test";

export class BasePage {
  readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async click(locator: Locator, options = {}) {
    const delay = Number(process.env.CLICK_DELAY) || 500;
    const defaultOptions = { delay: delay };
    const mergedOptions = { ...defaultOptions, ...options };

    await locator.click(mergedOptions);
  }
}
