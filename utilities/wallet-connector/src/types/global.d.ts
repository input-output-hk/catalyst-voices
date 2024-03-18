/// <reference types="vite/client" />

declare module globalThis {
  const cardano: Record<string, unknown>;
  export { cardano };
}
