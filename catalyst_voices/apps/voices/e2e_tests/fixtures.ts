import { mergeTests } from "@playwright/test";
import { test as walletTest } from "./fixtures/wallet-fixtures";
import { test as endpointTest } from "./fixtures/endpoint-fixtures";

export const test = mergeTests(walletTest, endpointTest);
