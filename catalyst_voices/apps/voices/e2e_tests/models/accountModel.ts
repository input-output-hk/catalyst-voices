export class AccountModel {
  constructor(
    public name: string,
    public email: string = "",
    public isEmailVerified: boolean = false,
    public password: string,
    public isProposer: boolean = false,
    public seedPhrase: string[] = [],
    public isDummy: boolean = false,
    public seedPhrasePath: string = ""
  ) {}
}
