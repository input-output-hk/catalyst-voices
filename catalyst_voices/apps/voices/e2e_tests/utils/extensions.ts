export interface BrowserExtension {
  Name: BrowserExtensionName;
  Id: string;
  HomeUrl: string;
}

export enum BrowserExtensionName {
  Lace = "Lace",
  Typhon = "Typhon",
  Eternl = "Eternl",
  Yoroi = "Yoroi",
  Nufi = "Nufi",
}
/* cspell: disable */
export const browserExtensions: BrowserExtension[] = [
  {
    Name: BrowserExtensionName.Lace,
    Id: "gafhhkghbfjjkeiendhlofajokpaflmk",
    HomeUrl: "app.html#/setup",
  },
  {
    Name: BrowserExtensionName.Typhon,
    Id: "kfdniefadaanbjodldohaedphafoffoh",
    HomeUrl: "tab.html#/wallet/access/",
  },
  {
    Name: BrowserExtensionName.Eternl,
    Id: "kmhcihpebfmpgmihbkipmjlmmioameka",
    HomeUrl: "index.html#/app/preprod/welcome",
  },
  {
    Name: BrowserExtensionName.Yoroi,
    Id: "poonlenmfdfbjfeeballhiibknlknepo",
    HomeUrl: "main_window.html#",
  },
  {
    Name: BrowserExtensionName.Nufi,
    Id: "hbklpdnlgiadjhdadfnfmemmklbopbcm",
    HomeUrl: "/index.html#",
  },
];
/* cspell: enable */

export const getBrowserExtension = (
  name: BrowserExtensionName
): BrowserExtension => {
  const extension = browserExtensions.find(
    (extension) => extension.Name === name
  );
  if (!extension) {
    throw new Error(`Browser extension with name ${name} not found`);
  }
  return extension;
};
