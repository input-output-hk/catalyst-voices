import { n as networkIdList } from "./NetworkId.js";
import { jR as getMilkomedaParameter, a2 as now, jS as MilkomedaDB, jT as getAssetIdHash, f as computed, i as createTextVNode, q as createVNode, d as defineComponent, S as reactive, z as ref, D as watch, w as watchEffect } from "./index.js";
var types = {};
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.ProtocolMagic = exports.Explorers = exports.BackendEndpoints = exports.ProtocolNames = exports.NetworkNames = void 0;
  (function(NetworkNames) {
    NetworkNames["internalTestnet"] = "c1-internal";
    NetworkNames["devnet"] = "c1-devnet";
    NetworkNames["mainnet"] = "c1-mainnet";
  })(exports.NetworkNames || (exports.NetworkNames = {}));
  (function(ProtocolNames) {
    ProtocolNames["cardanoProtocol"] = "cardano";
    ProtocolNames["evmProtocol"] = "EVM";
  })(exports.ProtocolNames || (exports.ProtocolNames = {}));
  (function(BackendEndpoints) {
    BackendEndpoints["internalTestnet"] = "allowlist.flint-wallet.com";
    BackendEndpoints["devnet"] = "allowlist.flint-wallet.com";
    BackendEndpoints["mainnet"] = "allowlist-mainnet.flint-wallet.com";
  })(exports.BackendEndpoints || (exports.BackendEndpoints = {}));
  (function(Explorers) {
    Explorers["internalTestnet"] = "";
    Explorers["mainnet"] = "https://bridge-explorer.milkomeda.com/cardano-mainnet";
    Explorers["devnet"] = "https://bridge-explorer.milkomeda.com/cardano-devnet";
  })(exports.Explorers || (exports.Explorers = {}));
  (function(ProtocolMagic) {
    ProtocolMagic["internalTestnet"] = "internal.cardano-evm.c1";
    ProtocolMagic["devnet"] = "devnet.cardano-evm.c1";
    ProtocolMagic["mainnet"] = "mainnet.cardano-evm.c1";
  })(exports.ProtocolMagic || (exports.ProtocolMagic = {}));
})(types);
const evmAddressLength = 42;
const evmAddressPrefix = "0x";
const networkMetadataUrlKey = 87;
const networkMetadataAddressKey = 88;
const networkMetadataUrl = networkIdList.reduce((o2, n2) => {
  o2[n2] = n2 === "mainnet" ? types.ProtocolMagic.mainnet : null;
  return o2;
}, {});
let _assetList = [];
const networkExplorer = networkIdList.reduce((o2, n2) => {
  o2[n2] = null;
  return o2;
}, {});
networkExplorer.mainnet = "https://explorer-mainnet-cardano-evm.c1.milkomeda.com/address/###ADDRESS###/transactions";
networkExplorer.preview = "https://explorer-devnet-cardano-evm.c1.milkomeda.com/address/###ADDRESS###/transactions";
const isMilkomedaTx = (tx, networkId) => {
  const metadata = (tx == null ? void 0 : tx.metadata) ? tx == null ? void 0 : tx.metadata[String(networkMetadataUrlKey)] : null;
  if (metadata && networkMetadataUrl[networkId] && metadata.includes(networkMetadataUrl[networkId])) {
    return true;
  }
  return false;
};
const getNetworkExplorerUrl = (networkId, address) => {
  var _a;
  return ((_a = networkExplorer[networkId]) == null ? void 0 : _a.replace("###ADDRESS###", address)) ?? void 0;
};
const getNetworkExplorerUrlFromItx = (networkId, itx) => {
  if (!isMilkomedaTx(itx, networkId)) return void 0;
  const address = itx.metadata ? itx.metadata[String(networkMetadataAddressKey)] ?? null : null;
  if (!address) {
    return void 0;
  }
  let jsonValue = getJsonValue(address) ?? void 0;
  return jsonValue ? getNetworkExplorerUrl(networkId, jsonValue) : void 0;
};
const getJsonValue = (input) => {
  if (!input) {
    return null;
  }
  const value = input.match(/"string":"(.*?)"/);
  if (!value) {
    return null;
  }
  return value[1];
};
const isMilkomedaAddress = (address) => {
  return address.startsWith(evmAddressPrefix) && address.length === evmAddressLength;
};
const getMilkomedaData = async (networkId) => {
  const config = getMilkomedaParameter(networkId, {
    lastSyncTimestamp: 0,
    config: {
      ada: {
        minLovelace: 3e6,
        fromADAFeeLovelace: 1e5,
        toADAFeeGWei: 1e9
      },
      assets: [],
      current_address: "addr1w8pydstdswmdqmg2rdt59dzql3zgfp9pt8sulnjgalycwdsj9js7w",
      ttl_expiry: 0
    }
  });
  const timeToRefresh = config.value.lastSyncTimestamp + 60 * 60 * 1e3;
  if (config.value.lastSyncTimestamp === 0 || timeToRefresh <= now() || config.value.config.ttl_expiry <= now()) {
    return null;
  }
  if (_assetList.length === 0) {
    _assetList = await MilkomedaDB.getAssetList(networkId);
  }
  if (config.value.lastSyncTimestamp === 0) {
    return null;
  }
  return config.value;
};
const isMilkomedaToken = async (token, milkomedaData) => {
  const hash = getCip14TokenHash(token);
  return milkomedaData.assets.filter((asset) => asset.idCardano === hash.padEnd(64, "0")).length > 0;
};
const getCip14TokenHash = (token) => {
  let policyId = "";
  let tokenName = "";
  policyId = token.p;
  tokenName = token.l[0].t.a;
  return getAssetIdHash(policyId, tokenName);
};
const getCip14Hash = (policyId, tokenName) => {
  return getAssetIdHash(policyId, tokenName);
};
const getMinTxAmount = async (token, milkomedaData) => {
  const hash = getCip14Hash(token.p, token.t.a);
  let milkomedaAsset = milkomedaData.assets.find((asset) => asset.idCardano === hash.padEnd(64, "0"));
  if (milkomedaAsset) {
    return milkomedaAsset.minCNTInt;
  }
  return 0;
};
var t = { d: (e, n2) => {
  for (var o2 in n2) t.o(n2, o2) && !t.o(e, o2) && Object.defineProperty(e, o2, { enumerable: true, get: n2[o2] });
}, o: (e, t2) => Object.prototype.hasOwnProperty.call(e, t2) }, n = {};
function o(e, t2) {
  (null == t2 || t2 > e.length) && (t2 = e.length);
  for (var n2 = 0, o2 = new Array(t2); n2 < t2; n2++) o2[n2] = e[n2];
  return o2;
}
function r(e, t2) {
  if (e) {
    if ("string" == typeof e) return o(e, t2);
    var n2 = Object.prototype.toString.call(e).slice(8, -1);
    return "Object" === n2 && e.constructor && (n2 = e.constructor.name), "Map" === n2 || "Set" === n2 ? Array.from(e) : "Arguments" === n2 || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n2) ? o(e, t2) : void 0;
  }
}
function a(e) {
  return function(e2) {
    if (Array.isArray(e2)) return o(e2);
  }(e) || function(e2) {
    if ("undefined" != typeof Symbol && null != e2[Symbol.iterator] || null != e2["@@iterator"]) return Array.from(e2);
  }(e) || r(e) || function() {
    throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
  }();
}
function l(e, t2, n2) {
  return t2 in e ? Object.defineProperty(e, t2, { value: n2, enumerable: true, configurable: true, writable: true }) : e[t2] = n2, e;
}
t.d(n, { Z: () => j });
const c = (s = { computed: () => computed, createTextVNode: () => createTextVNode, createVNode: () => createVNode, defineComponent: () => defineComponent, reactive: () => reactive, ref: () => ref, watch: () => watch, watchEffect: () => watchEffect }, p = {}, t.d(p, s), p), i = (0, c.defineComponent)({ props: { data: { required: true, type: String }, onClick: Function }, render: function() {
  var e = this.data, t2 = this.onClick;
  return (0, c.createVNode)("span", { class: "vjs-tree-brackets", onClick: t2 }, [e]);
} }), u = (0, c.defineComponent)({ emits: ["change", "update:modelValue"], props: { checked: { type: Boolean, default: false }, isMultiple: Boolean, onChange: Function }, setup: function(e, t2) {
  var n2 = t2.emit;
  return { uiType: (0, c.computed)(function() {
    return e.isMultiple ? "checkbox" : "radio";
  }), model: (0, c.computed)({ get: function() {
    return e.checked;
  }, set: function(e2) {
    return n2("update:modelValue", e2);
  } }) };
}, render: function() {
  var e = this.uiType, t2 = this.model, n2 = this.$emit;
  return (0, c.createVNode)("label", { class: ["vjs-check-controller", t2 ? "is-checked" : ""], onClick: function(e2) {
    return e2.stopPropagation();
  } }, [(0, c.createVNode)("span", { class: "vjs-check-controller-inner is-".concat(e) }, null), (0, c.createVNode)("input", { checked: t2, class: "vjs-check-controller-original is-".concat(e), type: e, onChange: function() {
    return n2("change", t2);
  } }, null)]);
} }), d = (0, c.defineComponent)({ props: { nodeType: { required: true, type: String }, onClick: Function }, render: function() {
  var e = this.nodeType, t2 = this.onClick, n2 = "objectStart" === e || "arrayStart" === e;
  return n2 || "objectCollapsed" === e || "arrayCollapsed" === e ? (0, c.createVNode)("span", { class: "vjs-carets vjs-carets-".concat(n2 ? "open" : "close"), onClick: t2 }, [(0, c.createVNode)("svg", { viewBox: "0 0 1024 1024", focusable: "false", "data-icon": "caret-down", width: "1em", height: "1em", fill: "currentColor", "aria-hidden": "true" }, [(0, c.createVNode)("path", { d: "M840.4 300H183.6c-19.7 0-30.7 20.8-18.5 35l328.4 380.8c9.4 10.9 27.5 10.9 37 0L858.9 335c12.2-14.2 1.2-35-18.5-35z" }, null)])]) : null;
} });
var s, p;
function h(e) {
  return h = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(e2) {
    return typeof e2;
  } : function(e2) {
    return e2 && "function" == typeof Symbol && e2.constructor === Symbol && e2 !== Symbol.prototype ? "symbol" : typeof e2;
  }, h(e);
}
function f(e) {
  return Object.prototype.toString.call(e).slice(8, -1).toLowerCase();
}
function y(e) {
  var t2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : "root", n2 = arguments.length > 2 && void 0 !== arguments[2] ? arguments[2] : 0, o2 = arguments.length > 3 ? arguments[3] : void 0, r2 = o2 || {}, a2 = r2.key, l2 = r2.index, c2 = r2.type, i2 = void 0 === c2 ? "content" : c2, u2 = r2.showComma, d2 = void 0 !== u2 && u2, s2 = r2.length, p2 = void 0 === s2 ? 1 : s2, h2 = f(e);
  if ("array" === h2) {
    var g2 = v(e.map(function(e2, o3, r3) {
      return y(e2, "".concat(t2, "[").concat(o3, "]"), n2 + 1, { index: o3, showComma: o3 !== r3.length - 1, length: p2, type: i2 });
    }));
    return [y("[", t2, n2, { showComma: false, key: a2, length: e.length, type: "arrayStart" })[0]].concat(g2, y("]", t2, n2, { showComma: d2, length: e.length, type: "arrayEnd" })[0]);
  }
  if ("object" === h2) {
    var b2 = Object.keys(e), m2 = v(b2.map(function(o3, r3, a3) {
      return y(e[o3], /^[a-zA-Z_]\w*$/.test(o3) ? "".concat(t2, ".").concat(o3) : "".concat(t2, '["').concat(o3, '"]'), n2 + 1, { key: o3, showComma: r3 !== a3.length - 1, length: p2, type: i2 });
    }));
    return [y("{", t2, n2, { showComma: false, key: a2, index: l2, length: b2.length, type: "objectStart" })[0]].concat(m2, y("}", t2, n2, { showComma: d2, length: b2.length, type: "objectEnd" })[0]);
  }
  return [{ content: e, level: n2, key: a2, index: l2, path: t2, showComma: d2, length: p2, type: i2 }];
}
function v(e) {
  if ("function" == typeof Array.prototype.flat) return e.flat();
  for (var t2 = a(e), n2 = []; t2.length; ) {
    var o2 = t2.shift();
    Array.isArray(o2) ? t2.unshift.apply(t2, a(o2)) : n2.push(o2);
  }
  return n2;
}
function g(e) {
  var t2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : /* @__PURE__ */ new WeakMap();
  if (null == e) return e;
  if (e instanceof Date) return new Date(e);
  if (e instanceof RegExp) return new RegExp(e);
  if ("object" !== h(e)) return e;
  if (t2.get(e)) return t2.get(e);
  if (Array.isArray(e)) {
    var n2 = e.map(function(e2) {
      return g(e2, t2);
    });
    return t2.set(e, n2), n2;
  }
  var o2 = {};
  for (var r2 in e) o2[r2] = g(e[r2], t2);
  return t2.set(e, o2), o2;
}
function b(e, t2) {
  var n2 = Object.keys(e);
  if (Object.getOwnPropertySymbols) {
    var o2 = Object.getOwnPropertySymbols(e);
    t2 && (o2 = o2.filter(function(t3) {
      return Object.getOwnPropertyDescriptor(e, t3).enumerable;
    })), n2.push.apply(n2, o2);
  }
  return n2;
}
function m(e) {
  for (var t2 = 1; t2 < arguments.length; t2++) {
    var n2 = null != arguments[t2] ? arguments[t2] : {};
    t2 % 2 ? b(Object(n2), true).forEach(function(t3) {
      l(e, t3, n2[t3]);
    }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(n2)) : b(Object(n2)).forEach(function(t3) {
      Object.defineProperty(e, t3, Object.getOwnPropertyDescriptor(n2, t3));
    });
  }
  return e;
}
var C = { showLength: { type: Boolean, default: false }, showDoubleQuotes: { type: Boolean, default: true }, renderNodeKey: Function, renderNodeValue: Function, selectableType: String, showSelectController: { type: Boolean, default: false }, showLine: { type: Boolean, default: true }, showLineNumber: { type: Boolean, default: false }, selectOnClickNode: { type: Boolean, default: true }, nodeSelectable: { type: Function, default: function() {
  return true;
} }, highlightSelectedNode: { type: Boolean, default: true }, showIcon: { type: Boolean, default: false }, theme: { type: String, default: "light" }, showKeyValueSpace: { type: Boolean, default: true }, editable: { type: Boolean, default: false }, editableTrigger: { type: String, default: "click" }, onNodeClick: { type: Function }, onBracketsClick: { type: Function }, onIconClick: { type: Function }, onValueChange: { type: Function } };
const k = (0, c.defineComponent)({ name: "TreeNode", props: m(m({}, C), {}, { node: { type: Object, required: true }, collapsed: Boolean, checked: Boolean, style: Object, onSelectedChange: { type: Function } }), emits: ["nodeClick", "bracketsClick", "iconClick", "selectedChange", "valueChange"], setup: function(e, t2) {
  var n2 = t2.emit, o2 = (0, c.computed)(function() {
    return f(e.node.content);
  }), r2 = (0, c.computed)(function() {
    return "vjs-value vjs-value-".concat(o2.value);
  }), a2 = (0, c.computed)(function() {
    return e.showDoubleQuotes ? '"'.concat(e.node.key, '"') : e.node.key;
  }), l2 = (0, c.computed)(function() {
    return "multiple" === e.selectableType;
  }), s2 = (0, c.computed)(function() {
    return "single" === e.selectableType;
  }), p2 = (0, c.computed)(function() {
    return e.nodeSelectable(e.node) && (l2.value || s2.value);
  }), h2 = (0, c.reactive)({ editing: false }), y2 = function(t3) {
    var o3, r3, a3 = "null" === (r3 = null === (o3 = t3.target) || void 0 === o3 ? void 0 : o3.value) ? null : "undefined" === r3 ? void 0 : "true" === r3 || "false" !== r3 && (r3[0] + r3[r3.length - 1] === '""' || r3[0] + r3[r3.length - 1] === "''" ? r3.slice(1, -1) : "number" == typeof Number(r3) && !isNaN(Number(r3)) || "NaN" === r3 ? Number(r3) : r3);
    n2("valueChange", a3, e.node.path);
  }, v2 = (0, c.computed)(function() {
    var t3, n3 = null === (t3 = e.node) || void 0 === t3 ? void 0 : t3.content;
    return null === n3 ? n3 = "null" : void 0 === n3 && (n3 = "undefined"), "string" === o2.value ? '"'.concat(n3, '"') : n3 + "";
  }), g2 = function() {
    var t3 = e.renderNodeValue;
    return t3 ? t3({ node: e.node, defaultValue: v2.value }) : v2.value;
  }, b2 = function() {
    n2("bracketsClick", !e.collapsed, e.node);
  }, m2 = function() {
    n2("iconClick", !e.collapsed, e.node);
  }, C2 = function() {
    n2("selectedChange", e.node);
  }, k2 = function() {
    n2("nodeClick", e.node), p2.value && e.selectOnClickNode && n2("selectedChange", e.node);
  }, w2 = function(t3) {
    if (e.editable && !h2.editing) {
      h2.editing = true;
      var n3 = function e2(n4) {
        var o3;
        n4.target !== t3.target && (null === (o3 = n4.target) || void 0 === o3 ? void 0 : o3.parentElement) !== t3.target && (h2.editing = false, document.removeEventListener("click", e2));
      };
      document.removeEventListener("click", n3), document.addEventListener("click", n3);
    }
  };
  return function() {
    var t3, n3 = e.node;
    return (0, c.createVNode)("div", { class: { "vjs-tree-node": true, "has-selector": e.showSelectController, "has-carets": e.showIcon, "is-highlight": e.highlightSelectedNode && e.checked, dark: "dark" === e.theme }, onClick: k2, style: e.style }, [e.showLineNumber && (0, c.createVNode)("span", { class: "vjs-node-index" }, [n3.id + 1]), e.showSelectController && p2.value && "objectEnd" !== n3.type && "arrayEnd" !== n3.type && (0, c.createVNode)(u, { isMultiple: l2.value, checked: e.checked, onChange: C2 }, null), (0, c.createVNode)("div", { class: "vjs-indent" }, [Array.from(Array(n3.level)).map(function(t4, n4) {
      return (0, c.createVNode)("div", { key: n4, class: { "vjs-indent-unit": true, "has-line": e.showLine } }, null);
    }), e.showIcon && (0, c.createVNode)(d, { nodeType: n3.type, onClick: m2 }, null)]), n3.key && (0, c.createVNode)("span", { class: "vjs-key" }, [(t3 = e.renderNodeKey, t3 ? t3({ node: e.node, defaultKey: a2.value || "" }) : a2.value), (0, c.createVNode)("span", { class: "vjs-colon" }, [":".concat(e.showKeyValueSpace ? " " : "")])]), (0, c.createVNode)("span", null, ["content" !== n3.type && n3.content ? (0, c.createVNode)(i, { data: n3.content.toString(), onClick: b2 }, null) : (0, c.createVNode)("span", { class: r2.value, onClick: !e.editable || e.editableTrigger && "click" !== e.editableTrigger ? void 0 : w2, onDblclick: e.editable && "dblclick" === e.editableTrigger ? w2 : void 0 }, [e.editable && h2.editing ? (0, c.createVNode)("input", { value: v2.value, onChange: y2, style: { padding: "3px 8px", border: "1px solid #eee", boxShadow: "none", boxSizing: "border-box", borderRadius: 5, fontFamily: "inherit" } }, null) : g2()]), n3.showComma && (0, c.createVNode)("span", null, [","]), e.showLength && e.collapsed && (0, c.createVNode)("span", { class: "vjs-comment" }, [(0, c.createTextVNode)(" // "), n3.length, (0, c.createTextVNode)(" items ")])])]);
  };
} });
function w(e, t2) {
  var n2 = Object.keys(e);
  if (Object.getOwnPropertySymbols) {
    var o2 = Object.getOwnPropertySymbols(e);
    t2 && (o2 = o2.filter(function(t3) {
      return Object.getOwnPropertyDescriptor(e, t3).enumerable;
    })), n2.push.apply(n2, o2);
  }
  return n2;
}
function N(e) {
  for (var t2 = 1; t2 < arguments.length; t2++) {
    var n2 = null != arguments[t2] ? arguments[t2] : {};
    t2 % 2 ? w(Object(n2), true).forEach(function(t3) {
      l(e, t3, n2[t3]);
    }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(n2)) : w(Object(n2)).forEach(function(t3) {
      Object.defineProperty(e, t3, Object.getOwnPropertyDescriptor(n2, t3));
    });
  }
  return e;
}
const j = (0, c.defineComponent)({ name: "Tree", props: N(N({}, C), {}, { data: { type: [String, Number, Boolean, Array, Object], default: null }, collapsedNodeLength: { type: Number, default: 1 / 0 }, deep: { type: Number, default: 1 / 0 }, pathCollapsible: { type: Function, default: function() {
  return false;
} }, rootPath: { type: String, default: "root" }, virtual: { type: Boolean, default: false }, height: { type: Number, default: 400 }, itemHeight: { type: Number, default: 20 }, selectedValue: { type: [String, Array], default: function() {
  return "";
} }, collapsedOnClickBrackets: { type: Boolean, default: true }, style: Object, onSelectedChange: { type: Function }, theme: { type: String, default: "light" } }), slots: ["renderNodeKey", "renderNodeValue"], emits: ["nodeClick", "bracketsClick", "iconClick", "selectedChange", "update:selectedValue", "update:data"], setup: function(e, t2) {
  var n2 = t2.emit, o2 = t2.slots, i2 = (0, c.ref)(), u2 = (0, c.computed)(function() {
    return y(e.data, e.rootPath);
  }), d2 = function(t3, n3) {
    return u2.value.reduce(function(o3, r2) {
      var a2, c2 = r2.level >= t3 || r2.length >= n3, i3 = null === (a2 = e.pathCollapsible) || void 0 === a2 ? void 0 : a2.call(e, r2);
      return "objectStart" !== r2.type && "arrayStart" !== r2.type || !c2 && !i3 ? o3 : N(N({}, o3), {}, l({}, r2.path, 1));
    }, {});
  }, s2 = (0, c.reactive)({ translateY: 0, visibleData: null, hiddenPaths: d2(e.deep, e.collapsedNodeLength) }), p2 = (0, c.computed)(function() {
    for (var e2 = null, t3 = [], n3 = u2.value.length, o3 = 0; o3 < n3; o3++) {
      var r2 = N(N({}, u2.value[o3]), {}, { id: o3 }), a2 = s2.hiddenPaths[r2.path];
      if (e2 && e2.path === r2.path) {
        var l2 = "objectStart" === e2.type, c2 = N(N(N({}, r2), e2), {}, { showComma: r2.showComma, content: l2 ? "{...}" : "[...]", type: l2 ? "objectCollapsed" : "arrayCollapsed" });
        e2 = null, t3.push(c2);
      } else {
        if (a2 && !e2) {
          e2 = r2;
          continue;
        }
        if (e2) continue;
        t3.push(r2);
      }
    }
    return t3;
  }), h2 = (0, c.computed)(function() {
    var t3 = e.selectedValue;
    return t3 && "multiple" === e.selectableType && Array.isArray(t3) ? t3 : [t3];
  }), f2 = (0, c.computed)(function() {
    return !e.selectableType || e.selectOnClickNode || e.showSelectController ? "" : "When selectableType is not null, selectOnClickNode and showSelectController cannot be false at the same time, because this will cause the selection to fail.";
  }), v2 = function() {
    var t3 = p2.value;
    if (e.virtual) {
      var n3, o3 = e.height / e.itemHeight, r2 = (null === (n3 = i2.value) || void 0 === n3 ? void 0 : n3.scrollTop) || 0, a2 = Math.floor(r2 / e.itemHeight), l2 = a2 < 0 ? 0 : a2 + o3 > t3.length ? t3.length - o3 : a2;
      l2 < 0 && (l2 = 0);
      var c2 = l2 + o3;
      s2.translateY = l2 * e.itemHeight, s2.visibleData = t3.filter(function(e2, t4) {
        return t4 >= l2 && t4 < c2;
      });
    } else s2.visibleData = t3;
  }, b2 = function() {
    v2();
  }, m2 = function(t3) {
    var o3, l2, c2 = t3.path, i3 = e.selectableType;
    if ("multiple" === i3) {
      var u3 = h2.value.findIndex(function(e2) {
        return e2 === c2;
      }), d3 = a(h2.value);
      -1 !== u3 ? d3.splice(u3, 1) : d3.push(c2), n2("update:selectedValue", d3), n2("selectedChange", d3, a(h2.value));
    } else if ("single" === i3 && h2.value[0] !== c2) {
      var s3 = (o3 = h2.value, l2 = 1, function(e2) {
        if (Array.isArray(e2)) return e2;
      }(o3) || function(e2, t4) {
        var n3 = null == e2 ? null : "undefined" != typeof Symbol && e2[Symbol.iterator] || e2["@@iterator"];
        if (null != n3) {
          var o4, r2, a2 = [], l3 = true, c3 = false;
          try {
            for (n3 = n3.call(e2); !(l3 = (o4 = n3.next()).done) && (a2.push(o4.value), !t4 || a2.length !== t4); l3 = true) ;
          } catch (e3) {
            c3 = true, r2 = e3;
          } finally {
            try {
              l3 || null == n3.return || n3.return();
            } finally {
              if (c3) throw r2;
            }
          }
          return a2;
        }
      }(o3, l2) || r(o3, l2) || function() {
        throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
      }())[0], p3 = c2;
      n2("update:selectedValue", p3), n2("selectedChange", p3, s3);
    }
  }, C2 = function(e2) {
    n2("nodeClick", e2);
  }, w2 = function(e2, t3) {
    if (e2) s2.hiddenPaths = N(N({}, s2.hiddenPaths), {}, l({}, t3, 1));
    else {
      var n3 = N({}, s2.hiddenPaths);
      delete n3[t3], s2.hiddenPaths = n3;
    }
  }, j2 = function(t3, o3) {
    e.collapsedOnClickBrackets && w2(t3, o3.path), n2("bracketsClick", t3, o3);
  }, S2 = function(e2, t3) {
    w2(e2, t3.path), n2("iconClick", e2, t3);
  }, O = function(t3, o3) {
    var r2 = g(e.data), a2 = e.rootPath;
    new Function("data", "val", "data".concat(o3.slice(a2.length), "=val"))(r2, t3), n2("update:data", r2);
  };
  return (0, c.watchEffect)(function() {
    f2.value && function(e2) {
      throw new Error("[VueJSONPretty] ".concat(e2));
    }(f2.value);
  }), (0, c.watchEffect)(function() {
    p2.value && v2();
  }), (0, c.watch)(function() {
    return e.deep;
  }, function(t3) {
    t3 && (s2.hiddenPaths = d2(t3, e.collapsedNodeLength));
  }), (0, c.watch)(function() {
    return e.collapsedNodeLength;
  }, function(t3) {
    t3 && (s2.hiddenPaths = d2(e.deep, t3));
  }), function() {
    var t3, n3, r2 = null !== (t3 = e.renderNodeKey) && void 0 !== t3 ? t3 : o2.renderNodeKey, a2 = null !== (n3 = e.renderNodeValue) && void 0 !== n3 ? n3 : o2.renderNodeValue, l2 = s2.visibleData && s2.visibleData.map(function(t4) {
      return (0, c.createVNode)(k, { key: t4.id, node: t4, collapsed: !!s2.hiddenPaths[t4.path], theme: e.theme, showDoubleQuotes: e.showDoubleQuotes, showLength: e.showLength, checked: h2.value.includes(t4.path), selectableType: e.selectableType, showLine: e.showLine, showLineNumber: e.showLineNumber, showSelectController: e.showSelectController, selectOnClickNode: e.selectOnClickNode, nodeSelectable: e.nodeSelectable, highlightSelectedNode: e.highlightSelectedNode, editable: e.editable, editableTrigger: e.editableTrigger, showIcon: e.showIcon, showKeyValueSpace: e.showKeyValueSpace, renderNodeKey: r2, renderNodeValue: a2, onNodeClick: C2, onBracketsClick: j2, onIconClick: S2, onSelectedChange: m2, onValueChange: O, style: e.itemHeight && 20 !== e.itemHeight ? { lineHeight: "".concat(e.itemHeight, "px") } : {} }, null);
    });
    return (0, c.createVNode)("div", { ref: i2, class: { "vjs-tree": true, "is-virtual": e.virtual, dark: "dark" === e.theme }, onScroll: e.virtual ? b2 : void 0, style: e.showLineNumber ? N({ paddingLeft: "".concat(12 * Number(u2.value.length.toString().length), "px") }, e.style) : e.style }, [e.virtual ? (0, c.createVNode)("div", { class: "vjs-tree-list", style: { height: "".concat(e.height, "px") } }, [(0, c.createVNode)("div", { class: "vjs-tree-list-holder", style: { height: "".concat(p2.value.length * e.itemHeight, "px") } }, [(0, c.createVNode)("div", { class: "vjs-tree-list-holder-inner", style: { transform: "translateY(".concat(s2.translateY, "px)") } }, [l2])])]) : l2]);
  };
} });
var S = n.Z;
export {
  S,
  networkMetadataUrlKey as a,
  networkMetadataAddressKey as b,
  isMilkomedaTx as c,
  getNetworkExplorerUrlFromItx as d,
  getJsonValue as e,
  getMinTxAmount as f,
  getMilkomedaData as g,
  isMilkomedaToken as h,
  isMilkomedaAddress as i,
  networkMetadataUrl as n
};
