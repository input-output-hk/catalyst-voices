import { i_ as getRef, i$ as forceSetLS, K as networkId, d as defineComponent, z as ref, C as onMounted, c6 as getAssetIdBech32, hv as formatAssetName, w as watchEffect, D as watch, o as openBlock, c as createElementBlock, u as unref, n as normalizeClass, e as createBaseVNode, t as toDisplayString, j as createCommentVNode, a as createBlock, h as withCtx, i as createTextVNode, b as withModifiers } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const createIURL = (ref2) => {
  return {
    parameters: (ref2 == null ? void 0 : ref2.parameters) ?? []
  };
};
const createIExplorerItem = (ref2) => {
  return {
    id: (ref2 == null ? void 0 : ref2.id) ?? null,
    baseUrl: (ref2 == null ? void 0 : ref2.baseUrl) ?? "",
    abbrev: (ref2 == null ? void 0 : ref2.abbrev) ?? "",
    txUrl: (ref2 == null ? void 0 : ref2.txUrl) ?? null,
    blocksUrl: (ref2 == null ? void 0 : ref2.blocksUrl) ?? null,
    poolUrl: (ref2 == null ? void 0 : ref2.poolUrl) ?? null,
    addressUrl: (ref2 == null ? void 0 : ref2.addressUrl) ?? null,
    tokenUrl: (ref2 == null ? void 0 : ref2.tokenUrl) ?? null,
    policyUrl: (ref2 == null ? void 0 : ref2.policyUrl) ?? null,
    epochUrl: (ref2 == null ? void 0 : ref2.epochUrl) ?? null,
    stakeUrl: (ref2 == null ? void 0 : ref2.stakeUrl) ?? null
  };
};
var ExplorerSettings;
((ExplorerSettings2) => {
  ExplorerSettings2.EXPLORER = "explorer";
  ExplorerSettings2.TRANSACTION_EXPLORER = "transaction_explorer";
  ExplorerSettings2.BLOCK_EXPLORER = "block_explorer";
  ExplorerSettings2.POOL_EXPLORER = "pool_explorer";
  ExplorerSettings2.ADDRESS_EXPLORER = "address_explorer";
  ExplorerSettings2.STAKE_ADDRESS_EXPLORER = "stake_address_explorer";
  ExplorerSettings2.TOKEN_EXPLORER = "token_explorer";
  ExplorerSettings2.POLICY_EXPLORER = "policy_explorer";
  ExplorerSettings2.EPOCH_EXPLORER = "epoch_explorer";
  ExplorerSettings2.STAKE_EXPLORER = "stake_explorer";
})(ExplorerSettings || (ExplorerSettings = {}));
const getBlockExplorer = (networkId2) => getRef(ExplorerSettings.BLOCK_EXPLORER + "_" + networkId2, "").value;
const setBlockExplorer = (networkId2, id) => {
  getRef(ExplorerSettings.BLOCK_EXPLORER + "_" + networkId2, "").value = id;
  forceSetLS(ExplorerSettings.BLOCK_EXPLORER + "_" + networkId2, id);
};
const getPoolExplorer = (networkId2) => getRef(ExplorerSettings.POOL_EXPLORER + "_" + networkId2, "").value;
const setPoolExplorer = (networkId2, id) => {
  getRef(ExplorerSettings.POOL_EXPLORER + "_" + networkId2, "").value = id;
  forceSetLS(ExplorerSettings.POOL_EXPLORER + "_" + networkId2, id);
};
const getAddressExplorer = (networkId2) => getRef(ExplorerSettings.ADDRESS_EXPLORER + "_" + networkId2, "").value;
const setAddressExplorer = (networkId2, id) => {
  getRef(ExplorerSettings.ADDRESS_EXPLORER + "_" + networkId2, "").value = id;
  forceSetLS(ExplorerSettings.ADDRESS_EXPLORER + "_" + networkId2, id);
};
const getStakeAddressExplorer = (networkId2) => getRef(ExplorerSettings.STAKE_ADDRESS_EXPLORER + "_" + networkId2, "").value;
const setStakeAddressExplorer = (networkId2, id) => {
  getRef(ExplorerSettings.STAKE_ADDRESS_EXPLORER + "_" + networkId2, "").value = id;
  forceSetLS(ExplorerSettings.STAKE_ADDRESS_EXPLORER + "_" + networkId2, id);
};
const getTokenExplorer = (networkId2) => getRef(ExplorerSettings.TOKEN_EXPLORER + "_" + networkId2, "").value;
const setTokenExplorer = (networkId2, id) => {
  getRef(ExplorerSettings.TOKEN_EXPLORER + "_" + networkId2, "").value = id;
  forceSetLS(ExplorerSettings.TOKEN_EXPLORER + "_" + networkId2, id);
};
const getPolicyExplorer = (networkId2) => getRef(ExplorerSettings.POLICY_EXPLORER + "_" + networkId2, "").value;
const setPolicyExplorer = (networkId2, id) => {
  getRef(ExplorerSettings.POLICY_EXPLORER + "_" + networkId2, "").value = id;
  forceSetLS(ExplorerSettings.POLICY_EXPLORER + "_" + networkId2, id);
};
const getTransactionExplorer = (networkId2) => getRef(ExplorerSettings.TRANSACTION_EXPLORER + "_" + networkId2, "").value;
const setTransactionExplorer = (networkId2, id) => {
  getRef(ExplorerSettings.TRANSACTION_EXPLORER + "_" + networkId2, "").value = id;
  forceSetLS(ExplorerSettings.TRANSACTION_EXPLORER + "_" + networkId2, id);
};
const _explorerMap = {
  "cardanoscanPreview": createIExplorerItem({
    id: "cardanoscanPreview",
    baseUrl: "https://preview.cardanoscan.io/",
    abbrev: "Cardanoscan Preview",
    txUrl: createIURL({ parameters: ["transaction/", "<txhash>"] }),
    blocksUrl: createIURL({ parameters: ["block/", "<blockNo>"] }),
    poolUrl: createIURL({ parameters: ["pool/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["address/", "<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["token/", "<fingerprint>"] }),
    policyUrl: createIURL({ parameters: ["tokenPolicy/", "<policyid>"] }),
    epochUrl: createIURL({ parameters: ["epoch/", "<epochid>"] }),
    stakeUrl: createIURL({ parameters: ["stakeKey/", "<bech32>", "?tab=delegationhistory"] })
  }),
  "cardanoscanPreprod": createIExplorerItem({
    id: "cardanoscanPreprod",
    baseUrl: "https://preprod.cardanoscan.io/",
    abbrev: "Cardanoscan Preprod",
    txUrl: createIURL({ parameters: ["transaction/", "<txhash>"] }),
    blocksUrl: createIURL({ parameters: ["block/", "<blockNo>"] }),
    poolUrl: createIURL({ parameters: ["pool/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["address/", "<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["token/", "<fingerprint>"] }),
    policyUrl: createIURL({ parameters: ["tokenPolicy/", "<policyid>"] }),
    epochUrl: createIURL({ parameters: ["epoch/", "<epochid>"] }),
    stakeUrl: createIURL({ parameters: ["stakeKey/", "<bech32>", "?tab=delegationhistory"] })
  }),
  cardanoscan: createIExplorerItem({
    id: "cardanoscan",
    baseUrl: "https://cardanoscan.io/",
    abbrev: "Cardanoscan",
    txUrl: createIURL({ parameters: ["transaction/", "<txhash>"] }),
    blocksUrl: createIURL({ parameters: ["block/", "<blockNo>"] }),
    poolUrl: createIURL({ parameters: ["pool/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["address/", "<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["token/", "<fingerprint>"] }),
    policyUrl: createIURL({ parameters: ["tokenPolicy/", "<policyid>"] }),
    epochUrl: createIURL({ parameters: ["epoch/", "<epochid>"] }),
    stakeUrl: createIURL({ parameters: ["stakekey/", "<bech32>"] })
  }),
  cexplorerPreview: createIExplorerItem({
    id: "cexplorerPreview",
    baseUrl: "https://preview.cexplorer.io/",
    abbrev: "Cexplorer Preview",
    txUrl: createIURL({ parameters: ["tx/", "<txhash>"] }),
    blocksUrl: createIURL({ parameters: ["block/", "<blockHash>"] }),
    poolUrl: createIURL({ parameters: ["pool/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["address/", "<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["asset/", "<fingerprint>"] }),
    policyUrl: createIURL({ parameters: ["policy/", "<policyid>"] }),
    epochUrl: createIURL({ parameters: ["epoch/", "<epochid>"] }),
    stakeUrl: createIURL({ parameters: ["stake/", "<bech32>"] })
  }),
  cexplorerPreprod: createIExplorerItem({
    id: "cexplorerPreprod",
    baseUrl: "https://preprod.cexplorer.io/",
    abbrev: "Cexplorer Preprod",
    txUrl: createIURL({ parameters: ["tx/", "<txhash>"] }),
    blocksUrl: createIURL({ parameters: ["block/", "<blockHash>"] }),
    poolUrl: createIURL({ parameters: ["pool/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["address/", "<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["asset/", "<fingerprint>"] }),
    policyUrl: createIURL({ parameters: ["policy/", "<policyid>"] }),
    epochUrl: createIURL({ parameters: ["epoch/", "<epochid>"] }),
    stakeUrl: createIURL({ parameters: ["stake/", "<bech32>"] })
  }),
  cexplorer: createIExplorerItem({
    id: "cexplorer",
    baseUrl: "https://cexplorer.io/",
    abbrev: "Cexplorer",
    txUrl: createIURL({ parameters: ["tx/", "<txhash>"] }),
    blocksUrl: createIURL({ parameters: ["block/", "<blockHash>"] }),
    poolUrl: createIURL({ parameters: ["pool/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["address/", "<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["asset/", "<fingerprint>"] }),
    policyUrl: createIURL({ parameters: ["policy/", "<policyid>"] }),
    epochUrl: createIURL({ parameters: ["epoch/", "<epochid>"] }),
    stakeUrl: createIURL({ parameters: ["stake/", "<bech32>"] })
  }),
  adastat: createIExplorerItem({
    id: "adastat",
    baseUrl: "https://adastat.net/",
    abbrev: "AdaStat",
    txUrl: createIURL({ parameters: ["transactions/", "<txhash>"] }),
    blocksUrl: createIURL({ parameters: ["blocks/", "<blockHash>"] }),
    poolUrl: createIURL({ parameters: ["pools/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["addresses/", "<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["tokens/", "<fingerprint>"] }),
    policyUrl: createIURL({ parameters: ["policies/", "<policyid>"] }),
    epochUrl: createIURL({ parameters: ["epochs/", "<epochid>"] }),
    stakeUrl: createIURL({ parameters: ["addresses/", "<bech32>"] })
  }),
  poolpm: createIExplorerItem({
    id: "poolpm",
    baseUrl: "https://pool.pm/",
    abbrev: "Pool.pm",
    txUrl: null,
    blocksUrl: null,
    poolUrl: createIURL({ parameters: ["<poolid>"] }),
    addressUrl: createIURL({ parameters: ["<bech32>"] }),
    tokenUrl: createIURL({ parameters: ["<fingerprint>"] }),
    policyUrl: null,
    epochUrl: null,
    stakeUrl: createIURL({ parameters: ["<bech32>"] })
  }),
  pooltool: createIExplorerItem({
    id: "pooltool",
    baseUrl: "https://pooltool.io/",
    abbrev: "PoolTool.io",
    txUrl: null,
    blocksUrl: null,
    poolUrl: createIURL({ parameters: ["pool/", "<poolid>"] }),
    addressUrl: createIURL({ parameters: ["address/", "<bech32>"] }),
    tokenUrl: null,
    policyUrl: null,
    epochUrl: null,
    stakeUrl: null
  }),
  poolpeek: createIExplorerItem({
    id: "poolpeek",
    baseUrl: "https://poolpeek.com/",
    abbrev: "Poolpeek",
    txUrl: null,
    blocksUrl: null,
    poolUrl: createIURL({ parameters: ["#/pool/", "<poolid>"] }),
    addressUrl: null,
    tokenUrl: null,
    policyUrl: null,
    epochUrl: null,
    stakeUrl: null
  })
};
const createExplorerList = () => {
  if (networkId.value === "preview") {
    return [
      getExplorerById("cardanoscanPreview"),
      getExplorerById("cexplorerPreview")
    ];
  } else if (networkId.value === "preprod") {
    return [
      getExplorerById("cardanoscanPreprod"),
      getExplorerById("cexplorerPreprod")
    ];
  } else if (networkId.value === "mainnet") {
    return [
      getExplorerById("adastat"),
      getExplorerById("cardanoscan"),
      getExplorerById("cexplorer"),
      getExplorerById("poolpeek"),
      getExplorerById("poolpm"),
      getExplorerById("pooltool")
    ];
  }
  return [];
};
const getExplorerList = () => createExplorerList();
const getExplorerById = (id) => _explorerMap[id];
const getExplorerByType = (type) => {
  const list = createExplorerList();
  let func = getAddressExplorer;
  switch (type) {
    case "address":
      func = getAddressExplorer;
      break;
    case "stake":
      func = getStakeAddressExplorer;
      break;
    case "block":
      func = getBlockExplorer;
      break;
    case "transaction":
      func = getTransactionExplorer;
      break;
    case "token":
      func = getTokenExplorer;
      break;
    case "pool":
      func = getPoolExplorer;
      break;
    case "policy":
      func = getPolicyExplorer;
      break;
  }
  let expl = func(networkId.value ?? "");
  if (!expl && networkId.value === "mainnet") {
    if (type === "token") {
      expl = "poolpm";
    } else {
      expl = "adastat";
    }
  }
  if (networkId.value === "preview") {
    expl = expl ? expl : "cardanoscanPreview";
  } else if (networkId.value === "preprod") {
    expl = expl ? expl : "cardanoscanPreprod";
  }
  return list.find((explorer) => explorer.id === expl) ?? null;
};
const setExplorerByType = (type, explorerId) => {
  const list = createExplorerList();
  const expl = list.find((explorer) => explorer.id === explorerId) ?? null;
  if (expl) {
    let func = setAddressExplorer;
    switch (type) {
      case "address":
        func = setAddressExplorer;
        break;
      case "stake":
        func = setStakeAddressExplorer;
        break;
      case "block":
        func = setBlockExplorer;
        break;
      case "transaction":
        func = setTransactionExplorer;
        break;
      case "token":
        func = setTokenExplorer;
        break;
      case "policy":
        func = setPolicyExplorer;
        break;
      case "pool":
        func = setPoolExplorer;
        break;
    }
    func(networkId.value, explorerId);
  }
};
function useExplorer() {
  return {
    getExplorerById,
    getExplorerByType,
    setExplorerByType,
    getExplorerList
  };
}
const _hoisted_1 = ["href"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ExplorerLink",
  props: {
    subject: { required: true },
    label: { type: String, required: true },
    type: { type: String, required: false },
    labelHover: { type: String, required: false, default: "" },
    labelCSS: { type: String, required: false, default: "" },
    icon: { type: String, required: false, default: "mdi mdi-open-in-new ml-1" },
    iconAlignLeft: { type: Boolean, required: false, default: false },
    itemsCenter: { type: Boolean, required: false, default: false },
    truncate: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    let absURL = ref("");
    let hover = ref(props.labelHover ?? "");
    const { getExplorerByType: getExplorerByType2 } = useExplorer();
    onMounted(() => {
      window.addEventListener("explorer-changed", (event) => {
        if (!networkId.value || !props.subject) {
          return;
        }
        updateUrl(networkId.value);
      });
    });
    function updateUrl(network) {
      absURL.value = "";
      if (!["mainnet", "preview", "preprod"].includes(networkId.value)) {
        return;
      }
      if (props.type) {
        hover.value = getHoverValue(props.type);
        absURL.value = getUrl(props.type, props.subject) ?? "";
      }
    }
    const getHoverValue = (type) => {
      const expl = getExplorerByType2(type);
      if (expl) {
        return t("setting.explorer." + expl.id + ".hover");
      }
      return "";
    };
    const getUrl = (type, subject) => {
      var _a, _b, _c, _d, _e, _f, _g;
      if (!subject) {
        return null;
      }
      const expl = getExplorerByType2(type);
      if (!expl) {
        return null;
      }
      switch (type) {
        case "address":
          if (subject.hash || subject.bech32) {
            return expl.addressUrl ? expl.baseUrl + ((_a = expl.addressUrl) == null ? void 0 : _a.parameters.map(
              (param) => param.replace("<hash>", subject.hash).replace("<bech32>", subject.bech32)
            ).join("")) : null;
          }
          return null;
        case "stake":
          if (subject.hash || subject.bech32) {
            return expl.stakeUrl ? expl.baseUrl + ((_b = expl.stakeUrl) == null ? void 0 : _b.parameters.map(
              (param) => param.replace("<hash>", subject.hash).replace("<bech32>", subject.bech32)
            ).join("")) : null;
          }
          return null;
        case "block":
          if (subject.blockNo || subject.blockHash) {
            return expl.blocksUrl ? expl.baseUrl + ((_c = expl.blocksUrl) == null ? void 0 : _c.parameters.map(
              (param) => param.replace("<blockNo>", subject.blockNo).replace("<blockHash>", subject.blockHash)
            ).join("")) : null;
          }
          return null;
        case "transaction":
          const hash = typeof subject === "string" ? subject : subject == null ? void 0 : subject.txHash;
          if (hash) {
            return expl.txUrl ? expl.baseUrl + ((_d = expl.txUrl) == null ? void 0 : _d.parameters.map(
              (param) => param.replace("<txhash>", hash)
            ).join("")) : null;
          }
          return null;
        case "token":
          const asset = subject;
          if (asset.p || asset.n || asset.f) {
            return expl.tokenUrl ? expl.baseUrl + ((_e = expl.tokenUrl) == null ? void 0 : _e.parameters.map(
              (param) => param.replace("<policyid>", asset.p ?? "").replace("<namehex>", asset.t.a).replace("<fingerprint>", asset.f ?? getAssetIdBech32(asset.p ?? "", asset.t.a ?? "")).replace("<name>", formatAssetName(asset.t.a))
            ).join("")) : expl.tokenUrl;
          }
          return null;
        case "policy":
          if (subject) {
            return expl.policyUrl ? expl.baseUrl + ((_f = expl.policyUrl) == null ? void 0 : _f.parameters.map(
              (param) => param.replace("<policyid>", subject)
            ).join("")) : null;
          }
          return null;
        case "pool":
          const poolHash = subject.ph ?? subject.hash ?? null;
          if (poolHash) {
            return expl.poolUrl ? expl.baseUrl + ((_g = expl.poolUrl) == null ? void 0 : _g.parameters.map(
              (param) => param.replace("<poolid>", poolHash)
            ).join("")) : null;
          }
          return null;
      }
      return null;
    };
    watchEffect(() => {
      if (!networkId.value || !props.subject) {
        return;
      }
      updateUrl(networkId.value);
    });
    watch(() => props.subject, () => {
      updateUrl(networkId.value);
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        onClick: _cache[0] || (_cache[0] = withModifiers(() => {
        }, ["stop"])),
        class: normalizeClass(["explorer-link cursor-pointer flex flex-row flex-nowrap justify-start", __props.truncate ? "truncate" : " " + (__props.itemsCenter ? "items-center" : "items-start")])
      }, [
        __props.label && unref(absURL) ? (openBlock(), createElementBlock("a", {
          key: 0,
          href: unref(absURL),
          target: "_blank",
          rel: "noopener noreferrer",
          class: normalizeClass(["flex flex-nowrap items-start justify-start", (__props.truncate ? "truncate" : "") + " " + (__props.iconAlignLeft ? "flex-row-reverse" : "flex-row")])
        }, [
          createBaseVNode("div", {
            class: normalizeClass([(__props.truncate ? "truncate" : "") + " " + __props.labelCSS, "self-center"])
          }, toDisplayString(__props.label), 3),
          __props.icon ? (openBlock(), createElementBlock("i", {
            key: 0,
            class: normalizeClass([__props.icon, ""])
          }, null, 2)) : createCommentVNode("", true),
          unref(hover) ? (openBlock(), createBlock(_sfc_main$1, {
            key: 1,
            "tooltip-c-s-s": "whitespace-nowrap",
            anchor: "bottom middle",
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createTextVNode(toDisplayString(unref(hover)), 1)
            ]),
            _: 1
          })) : createCommentVNode("", true)
        ], 10, _hoisted_1)) : (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["flex flex-nowrap items-start cursor-default", (__props.truncate ? "truncate" : "") + " " + (__props.iconAlignLeft ? "flex-row-reverse" : "flex-row")])
        }, [
          createBaseVNode("div", {
            class: normalizeClass([(__props.truncate ? "truncate" : "") + " " + __props.labelCSS, "self-center"])
          }, toDisplayString(__props.label), 3)
        ], 2))
      ], 2);
    };
  }
});
export {
  _sfc_main as _,
  useExplorer as u
};
