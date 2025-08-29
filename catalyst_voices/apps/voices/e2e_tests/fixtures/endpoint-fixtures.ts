import { test as base } from "@playwright/test";
import dotenv from "dotenv";

dotenv.config();

type EndpointFixtures = {
  appBaseURL: string;
};

export const test = base.extend<EndpointFixtures>({
  appBaseURL: async ({}, use) => {
    const baseURL =
      process.env.APP_URL || "https://app.dev.projectcatalyst.io/";
    await use(baseURL);
  },
});
