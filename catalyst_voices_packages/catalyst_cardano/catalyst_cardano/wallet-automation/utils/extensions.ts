export interface Extension {
  Name: string,
  Id: string
}

export enum ExtensionName {
  Lace = 'Lace',
  Typhon = 'Typhon'
}

const extensions: Extension[] = [
  { 
    Name: ExtensionName.Lace,
    Id: 'lace-id'
  },
  {
    Name: ExtensionName.Typhon,
    Id: 'typhon-id'
  }
];