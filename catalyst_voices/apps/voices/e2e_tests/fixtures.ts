import { mergeTests } from "@playwright/test";
import { test as browserTest } from "./fixtures/browser-fixtures";
import { test as endpointTest } from "./fixtures/endpoint-fixtures";

export const test = mergeTests(browserTest, endpointTest);
