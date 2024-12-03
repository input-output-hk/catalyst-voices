import { iM as useI18n, K as networkId } from "./index.js";
const useTranslation = () => {
  const i18n = useI18n();
  const it = (id) => i18n.t(id);
  const t = it;
  const itd = (id) => {
    const str = i18n.t(id, "####");
    return str === "####" ? "" : str;
  };
  const c = (id) => {
    const nw = networkId.value ?? "mainnet";
    if (id === "gradient") {
      if (nw === "mainnet") return "cc-mainnet-gradient";
      if (nw === "guild") return "cc-guild-gradient";
      if (nw === "sancho") return "cc-sancho-gradient";
      if (nw === "preprod") return "cc-testnet-gradient";
      if (nw === "preview") return "cc-testnet-gradient";
      if (nw === "afvt") return "cc-afv-gradient";
      if (nw === "afvm") return "cc-afv-gradient";
      if (nw === "afpt") return "cc-afp-gradient";
      if (nw === "afpm") return "cc-afp-gradient";
    }
    if (id === "border") {
      if (nw === "mainnet") return "cc-mainnet-walletbutton-border";
      if (nw === "guild") return "cc-guild-walletbutton-border";
      if (nw === "sancho") return "cc-sancho-walletbutton-border";
      if (nw === "preprod") return "cc-testnet-walletbutton-border";
      if (nw === "preview") return "cc-testnet-walletbutton-border";
      if (nw === "afvt") return "cc-af-walletbutton-border";
      if (nw === "afvm") return "cc-af-walletbutton-border";
      if (nw === "afpt") return "cc-af-walletbutton-border";
      if (nw === "afpm") return "cc-af-walletbutton-border";
    }
    if (id === "hover") {
      if (nw === "mainnet") return "cc-mainnet-walletbutton-hover";
      if (nw === "guild") return "cc-guild-walletbutton-hover";
      if (nw === "sancho") return "cc-sancho-walletbutton-hover";
      if (nw === "preprod") return "cc-testnet-walletbutton-hover";
      if (nw === "preview") return "cc-testnet-walletbutton-hover";
      if (nw === "afvt") return "cc-af-walletbutton-hover";
      if (nw === "afvm") return "cc-af-walletbutton-hover";
      if (nw === "afpt") return "cc-af-walletbutton-hover";
      if (nw === "afpm") return "cc-af-walletbutton-hover";
    }
    if (id === "hover-large") {
      if (nw === "mainnet") return "cc-mainnet-walletbutton-hover-large";
      if (nw === "guild") return "cc-guild-walletbutton-hover-large";
      if (nw === "sancho") return "cc-sancho-walletbutton-hover-large";
      if (nw === "preprod") return "cc-testnet-walletbutton-hover-large";
      if (nw === "preview") return "cc-testnet-walletbutton-hover-large";
      if (nw === "afvt") return "cc-af-walletbutton-hover-large";
      if (nw === "afvm") return "cc-af-walletbutton-hover-large";
      if (nw === "afpt") return "cc-af-walletbutton-hover-large";
      if (nw === "afpm") return "cc-af-walletbutton-hover-large";
    }
    if (id === "hover-locked") {
      if (nw === "mainnet") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "guild") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "sancho") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "preprod") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "preview") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "afvt") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "afvm") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "afpt") return "cc-mainnet-walletbutton-hover-locked";
      if (nw === "afpm") return "cc-mainnet-walletbutton-hover-locked";
    }
    return "";
  };
  return { it, itd, t, c };
};
export {
  useTranslation as u
};
