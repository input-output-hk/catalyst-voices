export class AccountModel {
  constructor(
    public id: string,
    public name: string,
    public email: string,
    public password: string,
    public isProposer: boolean = false
  ) {}
}