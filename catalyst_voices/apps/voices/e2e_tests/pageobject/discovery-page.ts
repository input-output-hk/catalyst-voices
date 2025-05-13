import { Page } from "@playwright/test";

export class DiscoveryPage {
    page: Page;

    constructor(page: Page) {
        this.page = page;
        
    }
}