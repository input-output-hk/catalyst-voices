import { AccountModel } from "../models/accountModel";

export const accountModels: AccountModel[] = [
  {
    id: "1",
    name: "testuser1",
    email: "testuser1@example.com",
    password: "Test1234!",
    isEmailVerified: false,
    isProposer: false,
    seedPhrase: [],
  },
];

export const getAccountModel = (id: string): AccountModel => {
  const accountModel = accountModels.find(
    (accountModel) => accountModel.id === id
  );
  if (!accountModel) {
    throw new Error(`Account model with id ${id} not found`);
  }
  return accountModel;
};

export const getAccountModels = (): AccountModel[] => accountModels;