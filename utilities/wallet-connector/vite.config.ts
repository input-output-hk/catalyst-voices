import react from "@vitejs/plugin-react-swc";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  return {
    resolve: {
      alias: {
        "cborg/lib/diagnostic": "../../node_modules/cborg/lib/diagnostic"
      }
    },
    server: {
      host: process.env["HOST"] || "127.0.0.1",
      port: Number(process.env["PORT"] || 3000),
      strictPort: true
    },
    plugins: [
      tsconfigPaths(),
      react()
    ],
  };
});
