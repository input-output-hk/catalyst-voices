/// <reference types="vite/client" />
/// <reference types="@cardano-sdk/cip30" />

declare module globalThis {
  const cardano: Record<string, any>
  export { cardano }
}
