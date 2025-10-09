import {
  BrowserExtensionModel,
  BrowserExtensionName,
} from "../models/browserExtensionModel";

/* cspell: disable */
export const browserExtensions: BrowserExtensionModel[] = [
  {
    Name: BrowserExtensionName.Lace,
    Id: "gafhhkghbfjjkeiendhlofajokpaflmk",
    HomeUrl: "/app.html#/setup",
  },
  {
    Name: BrowserExtensionName.Eternl,
    Id: "kmhcihpebfmpgmihbkipmjlmmioameka",
    HomeUrl: "/index.html#/app/preprod/welcome",
  },
  {
    Name: BrowserExtensionName.Yoroi,
    Id: "ffnbelfdoeiohenkjibnmadjiehjhajb",
    HomeUrl: "/main_window.html#",
  },
  {
    Name: BrowserExtensionName.Nufi,
    Id: "hbklpdnlgiadjhdadfnfmemmklbopbcm",
    HomeUrl: "/index.html#",
  },
  {
    Name: BrowserExtensionName.Vespr,
    Id: "bedogdpgdnifilpgeianmmdabklhfkcn",
    HomeUrl: "/index.html#/app/preprod/welcome",
  },
];
/* cspell: enable */

export const getBrowserExtension = (
  name: BrowserExtensionName
): BrowserExtensionModel => {
  const extension = browserExtensions.find(
    (extension) => extension.Name === name
  );
  if (!extension) {
    throw new Error(`Browser extension with name ${name} not found`);
  }
  return extension;
};
