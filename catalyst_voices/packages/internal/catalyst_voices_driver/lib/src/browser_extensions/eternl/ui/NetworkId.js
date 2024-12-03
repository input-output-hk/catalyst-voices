var INetworkFeature = /* @__PURE__ */ ((INetworkFeature2) => {
  INetworkFeature2[INetworkFeature2["NONE"] = 0] = "NONE";
  INetworkFeature2[INetworkFeature2["STAKING"] = 1] = "STAKING";
  INetworkFeature2[INetworkFeature2["SWAP"] = 2] = "SWAP";
  INetworkFeature2[INetworkFeature2["CATALYST"] = 4] = "CATALYST";
  INetworkFeature2[INetworkFeature2["GOVERNANCE"] = 8] = "GOVERNANCE";
  INetworkFeature2[INetworkFeature2["DAPP_BROWSER"] = 16] = "DAPP_BROWSER";
  INetworkFeature2[INetworkFeature2["REPORTING"] = 32] = "REPORTING";
  INetworkFeature2[INetworkFeature2["CREATE_SWAP"] = 64] = "CREATE_SWAP";
  INetworkFeature2[INetworkFeature2["ALL"] = 127] = "ALL";
  return INetworkFeature2;
})(INetworkFeature || {});
const networkIdList = ["mainnet", "preprod", "preview", "guild", "sancho", "afvt", "afpt", "afvm", "afpm"];
const networkGroups = {
  Cardano: ["mainnet", "preprod", "preview", "guild", "sancho"],
  APEX: ["afvt", "afvm", "afpt", "afpm"]
};
const networkFeaturesMap = networkIdList.reduce((o, n) => {
  o[n] = INetworkFeature.NONE;
  return o;
}, {});
networkFeaturesMap["mainnet"] = INetworkFeature.ALL;
networkFeaturesMap["guild"] = INetworkFeature.STAKING;
networkFeaturesMap["sancho"] = INetworkFeature.STAKING | INetworkFeature.DAPP_BROWSER | INetworkFeature.GOVERNANCE;
networkFeaturesMap["preprod"] = INetworkFeature.STAKING | INetworkFeature.DAPP_BROWSER | INetworkFeature.GOVERNANCE | INetworkFeature.SWAP | INetworkFeature.CREATE_SWAP | INetworkFeature.CATALYST;
networkFeaturesMap["preview"] = INetworkFeature.STAKING | INetworkFeature.DAPP_BROWSER | INetworkFeature.GOVERNANCE;
networkFeaturesMap["afpt"] = INetworkFeature.STAKING;
networkFeaturesMap["afpm"] = INetworkFeature.STAKING;
networkFeaturesMap["afvt"] = INetworkFeature.DAPP_BROWSER;
networkFeaturesMap["afvm"] = INetworkFeature.DAPP_BROWSER;
const networkAddressPrefix = {
  mainnet: "addr",
  sancho: "addr_test",
  guild: "addr_test",
  preprod: "addr_test",
  preview: "addr_test",
  afvt: "vector_test",
  // 'vector_test'
  afvm: "vector",
  // 'vector'
  afpt: "addr_test",
  afpm: "addr"
};
const isEnabledNetworkId = (id) => networkIdList.includes(id) && Object.keys(networkFeaturesMap).includes(id);
const isStakingEnabled = (networkId) => (networkFeaturesMap[networkId] & INetworkFeature.STAKING) !== 0;
const isDappBrowserEnabled = (networkId) => (networkFeaturesMap[networkId] & INetworkFeature.DAPP_BROWSER) !== 0;
const isSwapEnabled = (networkId) => (networkFeaturesMap[networkId] & INetworkFeature.SWAP) !== 0;
const isCreateSwapEnabled = (networkId) => (networkFeaturesMap[networkId] & INetworkFeature.CREATE_SWAP) !== 0;
const isCatalystEnabled = (networkId) => (networkFeaturesMap[networkId] & INetworkFeature.CATALYST) !== 0;
const isGovernanceEnabled = (networkId) => (networkFeaturesMap[networkId] & INetworkFeature.GOVERNANCE) !== 0;
const isReportingEnabled = (networkId) => (networkFeaturesMap[networkId] & INetworkFeature.REPORTING) !== 0;
let _devSettings = false;
const isDevSettingsEnabled = () => _devSettings;
const setDevSettingsEnabled = () => {
  _devSettings = true;
};
const updateNetworkFeaturesMap = (featuresMap) => {
  let changed = false;
  const oldNetworks = Object.keys(networkFeaturesMap);
  const newNetworks = Object.keys(featuresMap);
  if (oldNetworks.length !== newNetworks.length || newNetworks.some(
    (n) => !oldNetworks.includes(n) || networkFeaturesMap[n] !== featuresMap[n]
  )) {
    changed = true;
  }
  if (changed) {
    for (const key in networkFeaturesMap) {
      delete networkFeaturesMap[key];
    }
    for (const key in featuresMap) {
      networkFeaturesMap[key] = featuresMap[key];
    }
  }
  return changed;
};
const getNetworkId = (id) => {
  switch (id) {
    case "mainnet":
      return 1;
    case "guild":
      return 0;
    case "sancho":
      return 0;
    case "preprod":
      return 0;
    case "preview":
      return 0;
    case "afvt":
      return 2;
    case "afvm":
      return 3;
    case "afpt":
      return 0;
    case "afpm":
      return 1;
  }
  throw new Error("Error: INetwork.getNetworkId: unknown network: " + id);
};
const getNetworkDecimals = (id) => {
  switch (id) {
    case "sancho":
      return 6;
    default:
      return 6;
  }
};
const isSupportedNetworkId = (id) => networkIdList.includes(id);
const isTestnetNetwork = (networkId) => getNetworkId(networkId) === 0 || getNetworkId(networkId) === 2;
const isCustomNetwork = (networkId) => !isTestnetNetwork(networkId) && networkId !== "mainnet";
export {
  isCustomNetwork as a,
  isEnabledNetworkId as b,
  isSupportedNetworkId as c,
  networkAddressPrefix as d,
  isStakingEnabled as e,
  getNetworkDecimals as f,
  getNetworkId as g,
  networkGroups as h,
  isTestnetNetwork as i,
  isDappBrowserEnabled as j,
  isReportingEnabled as k,
  isDevSettingsEnabled as l,
  isSwapEnabled as m,
  networkIdList as n,
  isCatalystEnabled as o,
  isGovernanceEnabled as p,
  isCreateSwapEnabled as q,
  setDevSettingsEnabled as s,
  updateNetworkFeaturesMap as u
};
