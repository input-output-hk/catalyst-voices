export interface BrowserExtension {
  Name: BrowserExtensionName,
  Id: string
  HomeUrl: string
}

export enum BrowserExtensionName {
  Lace = 'Lace',
  Typhon = 'Typhon'
}

export const browserExtensions: BrowserExtension[] = [
  { 
    Name: BrowserExtensionName.Lace,
    Id: 'gafhhkghbfjjkeiendhlofajokpaflmk',
    HomeUrl: 'chrome-extension://gafhhkghbfjjkeiendhlofajokpaflmk/app.html#/setup'

  },
  {
    Name: BrowserExtensionName.Typhon,
    Id: 'kfdniefadaanbjodldohaedphafoffoh',
    HomeUrl: 'chrome-extension://kfdniefadaanbjodldohaedphafoffoh/tab.html#/wallet/access/'
  }
];

export const getBrowserExtension = (name: BrowserExtensionName): BrowserExtension => {
  const extension = browserExtensions.find(extension => extension.Name === name);
  if (!extension) {
    throw new Error(`Browser extension with name ${name} not found`);
  }
  return extension;
}