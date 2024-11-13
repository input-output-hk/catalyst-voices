export interface BrowserExtension {
  Name: BrowserExtensionName;
  Id: string;
  HomeUrl: string;
}

export enum BrowserExtensionName {
  Lace = "Lace",
  Typhon = "Typhon",
  Eternl = "Eternl",
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
