import { u as useBlacklist } from "./useBlacklist.js";
import { d as defineComponent, r as resolveComponent, o as openBlock, a as createBlock } from "./index.js";
import "./NetworkId.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AppLayout",
  setup(__props) {
    const { loadBlacklist } = useBlacklist();
    loadBlacklist();
    return (_ctx, _cache) => {
      const _component_router_view = resolveComponent("router-view");
      return openBlock(), createBlock(_component_router_view);
    };
  }
});
export {
  _sfc_main as default
};
