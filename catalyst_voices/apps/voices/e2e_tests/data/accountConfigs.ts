import { AccountModel } from "../models/accountModel";

/* cspell: disable */
export const accountModels: AccountModel[] = [
  {
    name: "DummyForTesting",
    email: "testuser1@example.com",
    password: "Test1234!",
    isEmailVerified: false,
    isProposer: true,
    seedPhrase: [],
    isDummy: true,
    seedPhrasePath: ""
  },
];
/* cspell: enable */

/**
 * Get the account model by name
 * @param name - The name of the account model
 * @returns The account model
 */
export const getAccountModel = (name: string): AccountModel => {
  const accountModel = accountModels.find((accountModel) => accountModel.name === name);
  if (!accountModel) {
    throw new Error(`Account model with name ${name} not found`);
  }
  return accountModel;
};

/**
 * Get all account models
 * @returns All account models
 */
export const getAccountModels = (): AccountModel[] => accountModels;
