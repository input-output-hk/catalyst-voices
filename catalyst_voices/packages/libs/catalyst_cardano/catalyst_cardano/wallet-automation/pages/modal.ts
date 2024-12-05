import { expect, Locator, Page } from "@playwright/test";

export enum ModalName {
  SignData = 'SignData',
  SignAndSubmitTx = 'SignAndSubmitTx',
  SignAndSubmitRBACTx = 'SignAndSubmitRBACTx',
  SignDataUserDeclined = 'UserDeclined',
  SignTxUserDeclined = 'SignTxUserDeclined',
  SignRBACTxUserDeclined = 'SignRBACTxUserDeclined',
}

export interface ModalContent {
  header: string;
  unchangingText: string;
}

export const modalContents: { [key in ModalName]: ModalContent } = {
  [ModalName.SignData]: {
    header: 'Sign data',
    unchangingText: 'Signature:',
  },
  [ModalName.SignAndSubmitTx]: {
    header: 'Sign & submit tx',
    unchangingText: 'Tx hash:',
  },
  [ModalName.SignAndSubmitRBACTx]: {
    header: 'Sign & submit RBAC tx',
    unchangingText: 'Tx hash:',
  },
  [ModalName.SignDataUserDeclined]: {
    header: 'Sign data',
    unchangingText: 'user declined sign data',
  },
  [ModalName.SignTxUserDeclined]: {
    header: 'Sign & submit tx',
    unchangingText: 'user declined sign tx',
  },
  [ModalName.SignRBACTxUserDeclined]: {
    header: 'Sign & submit RBAC tx',
    unchangingText: 'user declined sign tx',
  },
};

export class Modal {
  readonly page: Page;
  readonly content: ModalContent;
  readonly modalHeader: Locator;
  readonly modalBody: Locator;

  constructor(page: Page, modalName: ModalName) {
    this.page = page;
    this.content = modalContents[modalName];
    this.modalHeader = this.page.getByText(this.content.header, { exact: true });
    this.modalBody = this.page.getByText(this.content.unchangingText) 
  }

  async assertModalIsVisible() {
    await expect(this.modalHeader).toBeVisible();
    await expect(this.modalBody).toBeVisible();
  }
}