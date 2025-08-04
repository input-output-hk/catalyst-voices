export class BrowserExtensionModel {
  Name: BrowserExtensionName;
  Id: string;
  HomeUrl: string;
}

export enum BrowserExtensionName {
  Lace = "Lace",
  Eternl = "Eternl",
  Yoroi = "Yoroi",
  Nufi = "Nufi",
}
