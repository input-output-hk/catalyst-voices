export class AccountModel {
  constructor(
    public id: string,
    public name: string,
    public email: string = "",
    public isEmailVerified: boolean = false,
    public password: string,
    public isProposer: boolean = false,
    public seedPhrase: string[] = []
  ) {}
}
